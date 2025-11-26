$(document).ready(function () {
    // --- Configuración Inicial ---
    const token = localStorage.getItem('token');
    const apiBase = 'http://localhost:8080/api';
    const loginUrl = '../IniciodeSesión/index.html'; // Asegúrate de que esta ruta sea correcta

    // 1. VALIDACIÓN DE SESIÓN (MEJORA)
    if (!token) {
        console.warn("No hay token de autenticación. Redirigiendo al login.");
        // Redirige si no hay token al cargar la página
        // window.location.href = loginUrl;
        // return;
    }

    // --- Lógica de Navegación Activa ---
    const path = window.location.pathname.split("/").pop().toLowerCase();
    $(".sidebar nav .nav-link").each(function () {
        const href = $(this).attr("href")?.split("/").pop().toLowerCase();
        if (href === path) {
            $(this).addClass("active-link");
        } else {
            $(this).removeClass("active-link");
        }
    });

    // --- Funciones de Moderación ---

    /**
     * Carga y renderiza los comentarios pendientes de aprobación.
     * Muestra un indicador de carga y maneja errores de autenticación.
     */
    function loadPendingComments() {
        const tbody = $('#commentsTable tbody');
        // Indicador de carga (MEJORA UX)
        tbody.html('<tr><td colspan="4" class="text-center text-muted"><i class="fas fa-spinner fa-spin"></i> Cargando comentarios pendientes...</td></tr>');

        $.ajax({
            url: `${apiBase}/admin/comments/pending`,
            type: 'GET',
            headers: { 'Authorization': 'Bearer ' + token }
        })
        .done(function(data) {
            tbody.empty();

            const comments = data.content || data;

            if (comments.length === 0) {
                 tbody.append('<tr><td colspan="4" class="text-center text-secondary">No hay comentarios pendientes de moderación.</td></tr>');
                 return;
            }

            comments.forEach(comment => {
                const row = `
                    <tr data-id="${comment.id}">
                        <td class="text-secondary">${comment.contenido}</td>
                        <td class="text-secondary">${comment.usuarioNombre}</td>
                        <td class="text-secondary">${comment.recetaTitulo}</td>
                        <td>
                            <button class="btn btn-success btn-sm approve-btn">Aprobar</button>
                            <button class="btn btn-danger btn-sm delete-btn">Eliminar</button>
                        </td>
                    </tr>
                `;
                tbody.append(row);
            });
        })
        .fail(function(xhr) {
            // Manejo específico de errores 401 y 403 (MEJORA)
            let errorMessage = 'Error al cargar comentarios. ';

            if (xhr.status === 401) {
                errorMessage = 'Sesión expirada. Por favor, inicia sesión de nuevo.';
                // setTimeout(() => window.location.href = loginUrl, 2000);
            } else if (xhr.status === 403) {
                errorMessage = 'Permisos insuficientes. Solo los administradores pueden acceder aquí.';
            } else {
                errorMessage += (xhr.responseJSON?.message || xhr.statusText);
            }

            tbody.html(`<tr><td colspan="4" class="text-center text-danger">🚨 ${errorMessage}</td></tr>`);
        });
    }

    /**
     * Envía la petición para aprobar un comentario.
     */
    function approveComment(id) {
        $.ajax({
            url: `${apiBase}/admin/comments/${id}/approve`,
            type: 'PUT',
            headers: { 'Authorization': 'Bearer ' + token }
        })
        .done(function() {
            // El alert se puede reemplazar por un toast o notificación más elegante
            alert('Comentario aprobado exitosamente.'); 
            loadPendingComments(); // Recarga la tabla para reflejar el cambio
        })
        .fail(function(xhr) {
            alert('Error al aprobar comentario: ' + (xhr.responseJSON?.message || xhr.statusText));
        });
    }

    /**
     * Envía la petición para eliminar un comentario.
     */
    function deleteComment(id) {
        $.ajax({
            url: `${apiBase}/admin/comments/${id}`,
            type: 'DELETE',
            headers: { 'Authorization': 'Bearer ' + token }
        })
        .done(function() {
            alert('Comentario eliminado exitosamente.');
            loadPendingComments(); // Recarga la tabla
        })
        .fail(function(xhr) {
            alert('Error al eliminar comentario: ' + (xhr.responseJSON?.message || xhr.statusText));
        });
    }


    // --- Manejo de Eventos (Delegación) ---

    // Evento para Aprobar
    $(document).on('click', '.approve-btn', function () {
        const id = $(this).closest('tr').data('id');
        // Deshabilita el botón mientras se procesa (MEJORA UX)
        $(this).prop('disabled', true).text('...');
        approveComment(id);
    });

    // Evento para Eliminar
    $(document).on('click', '.delete-btn', function () {
        const id = $(this).closest('tr').data('id');
        if(confirm('¿Seguro que deseas eliminar permanentemente este comentario?')) {
            // Deshabilita el botón mientras se procesa (MEJORA UX)
            $(this).prop('disabled', true).text('...');
            deleteComment(id);
        }
    });

    // --- Ejecución Inicial ---
    // Cargar comentarios al iniciar si el token existe
    if (token) {
        loadPendingComments();
    }
});
