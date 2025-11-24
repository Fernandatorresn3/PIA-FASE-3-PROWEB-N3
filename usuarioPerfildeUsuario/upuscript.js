$(document).ready(function() {

    const token = localStorage.getItem('token');

    function loadProfile() {
        $.ajax({
            url: '/api/profile/me',
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
            url: '/api/auth/logout',
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
        $('#editDescripcion').val($('#shortDescription').text());
        $('#editEmail').val($('#email').text());
        $('#editProfileModal').modal('show');
    });

    //Guardar cambios
    $('#editProfileForm').submit(function(e) {
        e.preventDefault();
        const updatedData = {
            nombre: $('#editNombre').val(),
            apellido: $('#editApellido').val(),
            descripcion: $('#editDescripcion').val(),
            email: $('#editEmail').val()
        };

        $.ajax({
            url: '/api/profile/me',
            type: 'PUT',
            headers: { 'Authorization': 'Bearer ' + token },
            contentType: 'application/json',
            data: JSON.stringify(updatedData)
        }).done(function(data) {
            $('#nombre').text(data.nombre);
            $('#apellido').text(data.apellido);
            $('#shortDescription').text(data.descripcion || ' ');
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
   $('.navbar-nav .nav-link').each(function(){
    const href = $(this).attr('href');
    if(window.location.href.includes(href)){
        $(this).addClass('current');
    }else{
        $(this).removeClass('current');
    }
   });
});
