$(document).ready(function (){

    const path = window.location.pathname.split("/").pop().toLowerCase();
    $(".sidebar nav .nav-link").each(function () {
        const href = $(this).attr("href")?.split("/").pop().toLowerCase();
        if (href === path) { $(this).addClass("active-link"); } 
        else { $(this).removeClass("active-link"); }
    });

    // --- CONEXIÓN API ---
    const API_RECIPES = "http://localhost:8080/api/recipes"; 
    
    const token = localStorage.getItem('token');

    if (!token) {
        console.warn("No hay token, redirigiendo al login...");
        // window.location.href = "../IniciodeSesión/index.html";
    }

    function cargarReportes() {
        $.ajax({
            url: API_RECIPES,
            type: 'GET',
            headers: { 
                'Authorization': 'Bearer ' + token 
            },
            success: function(recetas) {
                console.log("Recetas cargadas:", recetas);
                procesarYRenderizar(recetas);
            },
            error: function(xhr) {
                console.error("Error cargando recetas:", xhr);
                // Mensaje si falla
                let mensaje = "Error cargando datos";
                if(xhr.status === 403) mensaje = "No tienes permisos (403)";
                if(xhr.status === 401) mensaje = "Sesión expirada (401)";
                
                $("#tablaMejorCalificadas").html(`<tr><td colspan="2" class="text-danger text-center">${mensaje}</td></tr>`);
            }
        });
    }

    function procesarYRenderizar(recetas) {
        // A. Top 5 Mejor Calificadas
        const topCalificadas = [...recetas]
            .sort((a, b) => b.calificacionPromedio - a.calificacionPromedio)
            .slice(0, 5);

        // B. Top 5 Más Comentadas
        const topComentadas = [...recetas]
            .sort((a, b) => b.totalComentarios - a.totalComentarios)
            .slice(0, 5);

        // C. Top 5 Más Guardadas 
        const topGuardadas = [...recetas]
            .sort((a, b) => b.totalCalificaciones - a.totalCalificaciones)
            .slice(0, 5);

        llenarTabla("#tablaMejorCalificadas", topCalificadas, "calificacionPromedio", true);
        llenarTabla("#tablaMasComentadas", topComentadas, "totalComentarios", false);
        llenarTabla("#tablaMasGuardadas", topGuardadas, "totalCalificaciones", false);
    }

    function llenarTabla(selector, datos, propiedad, esDecimal) {
        const tbody = $(selector);
        tbody.empty();
        
        if (!datos || datos.length === 0) {
            tbody.append('<tr><td colspan="2" class="text-muted text-center">No hay datos suficientes</td></tr>');
            return;
        }

        datos.forEach(item => {
            const valorRaw = item[propiedad] || 0;
            const valorDisplay = esDecimal ? valorRaw.toFixed(1) : valorRaw;
            
            const fila = `
                <tr>
                    <td>${item.titulo}</td>
                    <td class="text-end fw-bold">${valorDisplay}</td>
                </tr>
            `;
            tbody.append(fila);
        });
    }

    // Ejecutar
    cargarReportes();

});