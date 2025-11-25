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
            url: API_RECIPES + "?pagina=0&limite=100", // Obtener muchas recetas para análisis
            type: 'GET',
            headers: { 
                'Authorization': 'Bearer ' + token 
            },
            success: function(response) {
                console.log("Recetas cargadas:", response);
                //El endpoint devuelve una estructura paginada con "content"
                const recetas = response.content || response;
                if (!recetas || recetas.length === 0) {
                    console.warn("No hay recetas disponibles");
                    $("tablaMejorCalificadas, #tablaMasComentadas, #tablaMasGuardadas").html(
                        `<tr><td colspan="2" class="text-danger text-center">No hay datos disponibles</td></tr>`
                    );
                    return;
                }                                                                                                                                         
                procesarYRenderizar(recetas);
            },
            error: function(xhr) {
            
                if(xhr.status === 403) mensaje = "No tienes permisos (403)";
                if(xhr.status === 401) mensaje = "Sesión expirada (401)";
                
                $("#tablaMejorCalificadas, #tablaMasComentadas, #tablaMasGuardadas").html(
                    `<tr><td colspan="2" class="text-danger text-center">${mensaje}</td></tr>`);
            }
        });
    }

    function procesarYRenderizar(recetas) {
        // A. Top 5 Mejor Calificadas (por calificación promedio)
        const topCalificadas = [...recetas]
        .filter(r => r.calificacionPromedio > 0)
            .sort((a, b) => b.calificacionPromedio - a.calificacionPromedio)
            .slice(0, 5);

        // B. Top 5 Más Comentadas
        const topComentadas = [...recetas]
        .filter(r => r.totalComentarios > 0)
            .sort((a, b) => b.totalComentarios - a.totalComentarios)
            .slice(0, 5);

        // C. Top 5 Más Guardadas (Usando totalCalificaciones como proxy de popularidad)
        //Nota: totalcalificaciones representa el  numero de valoraciones que tiene la receta 
        const topGuardadas = [...recetas]
        .filter(r => r.totalCalificaciones > 0)
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