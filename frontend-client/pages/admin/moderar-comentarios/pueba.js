$(document).ready(function () {

    // Activar el link del panel actual
    const path = window.location.pathname.split("/").pop().toLowerCase();
    $(".sidebar nav .nav-link").each(function () {
        const href = $(this).attr("href").split("/").pop().toLowerCase();
        if (href === path) {
            $(this).addClass("active-link");
        } else {
            $(this).removeClass("active-link");
        }
    });

    // COMENTARIOS
    const token = localStorage.getItem('token');
    const apiBase = 'http://localhost:8080/api';

    function loadPendingComments() {
        $.ajax({
            url: `${apiBase}/admin/comments/pending`,
            type: 'GET',
            headers: { 'Authorization': 'Bearer ' + token }
        })
        .done(function(comments) {
            const tbody = $('#commentsTable tbody');
            tbody.empty();

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
            alert('Error al cargar comentarios: ' + (xhr.responseJSON?.message || xhr.statusText));
        });
    }

    // Aprobar comentario
    $(document).on('click', '.approve-btn', function () {
        const id = $(this).closest('tr').data('id');
        $.ajax({
            url: `${apiBase}/admin/comments/${id}/approve`,
            type: 'PUT',
            headers: { 'Authorization': 'Bearer ' + token }
        })
        .done(function() {
            alert('Comentario aprobado.');
            loadPendingComments();
        })
        .fail(function(xhr) {
            alert('Error al aprobar comentario: ' + (xhr.responseJSON?.message || xhr.statusText));
        });
    });

    // Eliminar comentario
    $(document).on('click', '.delete-btn', function () {
        const id = $(this).closest('tr').data('id');
        if(confirm('¿Seguro que deseas eliminar este comentario?')) {
            $.ajax({
                url: `${apiBase}/admin/comments/${id}`,
                type: 'DELETE',
                headers: { 'Authorization': 'Bearer ' + token }
            })
            .done(function() {
                alert('Comentario eliminado.');
                loadPendingComments();
            })
            .fail(function(xhr) {
                alert('Error al eliminar comentario: ' + (xhr.responseJSON?.message || xhr.statusText));
            });
        }
    });

    // Cargar comentarios al iniciar
    loadPendingComments();
});
