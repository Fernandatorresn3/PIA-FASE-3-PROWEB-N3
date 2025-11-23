$(document).ready(function() {

    const token = localStorage.getItem('token');

    function loadProfile() {
        $.ajax({
            url: 'http://localhost:8080/api/profile/me',
            type: 'GET',
            headers: { 'Authorization': 'Bearer ' + token }
        }).done(function(data) {
            $('#profilePhoto').attr('src', data.imagenPerfil || 'default.png');
            $('#fullName').text(data.nombre + " " + data.apellido);
            $('#shortDescription').text(data.descripcion || '');
            $('#nombre').text(data.nombre);
            $('#apellido').text(data.apellido);
            $('#email').text(data.email);
            $('#fechaRegistro').text(data.fechaRegistro);
            $('#profileIcon').attr('src', data.fotoPerfil || '....');
        });
    }

    loadProfile();

    //Cerrar sesión
    $('#logoutBtn').click(function(e) {
        e.preventDefault();
        $.ajax({
            url: 'http://localhost:8080/api/auth/logout',
            type: 'POST',
            headers: { 'Authorization': 'Bearer ' + token }
        }).always(function() {
            localStorage.removeItem('token');
            window.location.href = '...'; // Página de inicio de sesión
        });
    });

    //Abrir modal editar
    $('#editProfileBtn').click(function() {
        $('#editNombre').val($('#nombre').text());
        $('#editApellido').val($('#apellido').text());
        $('#editEmail').val($('#email').text());
        $('#editProfileModal').modal('show');
    });

    //Guardar cambios
    $('#editProfileForm').submit(function(e) {
        e.preventDefault();
        const updatedData = {
            nombre: $('#editNombre').val(),
            apellido: $('#editApellido').val(),
            email: $('#editEmail').val()
        };

        $.ajax({
            url: 'http://localhost:8080/api/profile/me',
            type: 'PUT',
            headers: { 'Authorization': 'Bearer ' + token },
            contentType: 'application/json',
            data: JSON.stringify(updatedData)
        }).done(function(data) {
            $('#nombre').text(data.nombre);
            $('#apellido').text(data.apellido);
            $('#email').text(data.email);
            $('#fullName').text(data.nombre + " " + data.apellido);
            $('#editProfileModal').modal('hide');
        });
    });

    //Enlaces
    $('#viewFeaturedBtn').click(function() {
        window.location.href = '....';
    });

    //Resaltar página activa
    const path = window.location.pathname;
    if(path.includes("perfil")) $('#linkPerfil').addClass('current');
    else if(path.includes("recetas")) $('#linkRecetas').addClass('current');
    else $('#linkInicio').addClass('current');
});
