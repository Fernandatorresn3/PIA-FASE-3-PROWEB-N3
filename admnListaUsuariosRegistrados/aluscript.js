$(document).ready(function (){

    // MENÚ ACTIVO
    const path = window.location.pathname.split("/").pop().toLowerCase();
    $(".sidebar nav .nav-link").each(function () {
        const href = $(this).attr("href")?.split("/").pop().toLowerCase();
        if (href === path) { $(this).addClass("active-link"); } 
        else { $(this).removeClass("active-link"); }
    });

    const $tbody = $("#tablaUsuarios");
    let idUsuarioAEliminar = null;
    let filaAEliminar = null;

    // ==========================================
    // PARTE 1: DATOS VISUALES (MOCK DATA)
    // ==========================================
    
    // Datos copiados del PDF para visualización inmediata
    const usuariosMock = [
        { id: 1, username: "Carlos Pérez", email: "carlos.perez@example.com" },
        { id: 2, username: "Ana García", email: "ana.garcia@example.com" },
        { id: 3, username: "Luis Martínez", email: "luis.martinez@example.com" },
        { id: 4, username: "Sofía Rodríguez", email: "sofia.rodriguez@example.com" },
        { id: 5, username: "Javier López", email: "javier.lopez@example.com" }
    ];

    renderizarTabla(usuariosMock);


    // ==========================================
    // PARTE 2: CONEXIÓN REAL (PARA EL BACKEND)
    // ==========================================
    /*
       COMPAÑERO DE BACKEND: Descomenta esto para conectar con la API real.
    */
    
    /*
    const API_URL = "http://localhost:8080/api/admin/users";
    const token = localStorage.getItem('token'); 

    function cargarUsuariosReales() {
        $.ajax({
            url: API_URL,
            type: 'GET',
            headers: { 'Authorization': 'Bearer ' + token },
            success: function(usuarios) {
                renderizarTabla(usuarios);
            },
            error: function(xhr) {
                console.log("Backend no disponible, usando datos falsos.");
            }
        });
    }
    // cargarUsuariosReales();
    */


    // --- FUNCIONES DE UTILIDAD ---
    function renderizarTabla(datos) {
        $tbody.empty();
        datos.forEach(usuario => {
            const fila = `
                <tr>
                    <td class="ps-4 fw-bold text-muted">${usuario.id}</td>
                    <td>${usuario.username}</td>
                    <td>${usuario.email}</td>
                    <td>
                        <button class="btn btn-link text-danger p-0 fw-bold btn-eliminar" data-id="${usuario.id}" style="text-decoration:none;">
                            Eliminar Usuario
                        </button>
                    </td>
                </tr>
            `;
            $tbody.append(fila);
        });
    }

    // Lógica visual del botón Eliminar
    $(document).on("click", ".btn-eliminar", function() {
        filaAEliminar = $(this).closest("tr");
        idUsuarioAEliminar = $(this).data("id");
        const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
        deleteModal.show();
    });

    $("#confirmDeleteBtn").click(function() {
        // BORRADO VISUAL (Sin llamar al backend por ahora)
        if (filaAEliminar) {
            filaAEliminar.fadeOut(300, function() { $(this).remove(); });
            const modalEl = document.getElementById('deleteModal');
            const modal = bootstrap.Modal.getInstance(modalEl);
            modal.hide();
        }

        /* PARA BACKEND: Descomentar esto para hacer el DELETE real:
           
           $.ajax({
               url: "http://localhost:8080/api/admin/users/" + idUsuarioAEliminar,
               type: 'DELETE',
               headers: { 'Authorization': 'Bearer ' + localStorage.getItem('token') },
               success: function() { ...borrar fila... }
           });
        */
    });

});