$(document).ready(function (){

    // Configuración inicial
    const path = window.location.pathname.split("/").pop().toLowerCase();
    $(".sidebar nav .nav-link").each(function () {
        const href = $(this).attr("href")?.split("/").pop().toLowerCase();
        if (href === path) { $(this).addClass("active-link"); } 
        else { $(this).removeClass("active-link"); }
    });

    const API_URL = "http://localhost:8080/api/admin/users";
    const token = localStorage.getItem('token'); 
    const $tbody = $("#tablaUsuarios");
    let idUsuarioAEliminar = null;
    let filaAEliminar = null;

    // Datos de respaldo (Por si el usuario no es Admin o falla el server)
    const usuariosBackup = [
        { id: 1, username: "Carlos Pérez", email: "carlos.perez@example.com" },
        { id: 2, username: "Ana García", email: "ana.garcia@example.com" },
        { id: 3, username: "Luis Martínez", email: "luis.martinez@example.com" },
        { id: 4, username: "Sofía Rodríguez", email: "sofia.rodriguez@example.com" },
        { id: 5, username: "Javier López", email: "javier.lopez@example.com" }
    ];

    function cargarUsuarios() {
        $.ajax({
            url: API_URL,
            type: 'GET',
            headers: { 'Authorization': 'Bearer ' + token },
            success: function(response) {
                // El backend devuelve una estructura paginada con "content"
                const usuarios = response.content || response;
                renderizarTabla(usuarios);
            },
            error: function(xhr) {
                console.warn("No se pudo cargar de la API. Error.", xhr.status);
                console.warn("Cargando datos de respaldo.");
                renderizarTabla(usuariosBackup);
            }
        });
    }

    function renderizarTabla(datos) {
        $tbody.empty();
        
        if (!datos || datos.length === 0) {
            $tbody.html('<tr><td colspan="4" class="text-center text-muted">No hay datos</td></tr>');
            return;
        }

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

    $(document).on("click", ".btn-eliminar", function() {
        filaAEliminar = $(this).closest("tr");
        idUsuarioAEliminar = $(this).data("id");
        const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
        deleteModal.show();
    });

    $("#confirmDeleteBtn").click(function() {
        $.ajax({
            url: API_URL + "/" + idUsuarioAEliminar,
            type: 'DELETE',
            headers: { 'Authorization': 'Bearer ' + token },
            success: function() {
                eliminarFilaVisual();
            },
            error: function() {
                console.warn("Simulando eliminación visual");
                eliminarFilaVisual();
            }
        });
    });

    function eliminarFilaVisual() {
        if (filaAEliminar) {
            filaAEliminar.fadeOut(300, function() { $(this).remove(); });
            const modalEl = document.getElementById('deleteModal');
            const modal = bootstrap.Modal.getInstance(modalEl);
            modal.hide();
        }
    }

    cargarUsuarios();

});