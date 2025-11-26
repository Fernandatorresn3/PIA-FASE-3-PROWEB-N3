$(document).ready(function() {

    const token = localStorage.getItem('token');

    function loadProfile() {
        $.ajax({
            url: 'http://localhost:8080/api/profile/me',
            type: 'GET',
            headers: { 'Authorization': 'Bearer ' + token }
        }).done(function(data) {
            $('#profilePhoto').attr('src', data.imagenPerfil || 'default.png');
            $('#fullName').text(data.username);
            $('#shortDescription').text(data.descripcion || '');
            $('#nombre').text(data.username);
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
            localStorage.removeItem('user');
            window.location.href = '../../public/login/InicioDeSesion.html';
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
        window.location.href = '../recetas-destacadas/RecetasDestacadas.html';
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

       // Insertar botón de Dashboard si el usuario es admin
    function setupAdminButton() {
        const userStr = localStorage.getItem('user');
        if (!userStr) return;
        try {
            const userObj = JSON.parse(userStr);
            // Soportar tanto user.role como user.roles (array) por seguridad
            const isAdmin = (userObj && (userObj.role === 'ROLE_ADMIN' || (Array.isArray(userObj.roles) && userObj.roles.includes('ROLE_ADMIN'))));
            if (isAdmin) {
                const adminBtnHtml = `<a id="adminBtn" class="btn btn-warning btn-sm me-2" href="../../admin/dashboard/appindex.html"><i class="bi bi-speedometer2"></i> Dashboard</a>`;
                const $logout = $('#logoutBtn');
                if ($logout.length) {
                    $logout.before(adminBtnHtml);
                } else {
                    // Fallback: intentar añadir al elemento con id 'navbar' si existe
                    const $nav = $('#navbar');
                    if ($nav.length) {
                        $nav.append(adminBtnHtml);
                    } else {
                        // Si no hay donde insertarlo, loguear para depuración
                        console.warn('No se encontró #logoutBtn ni #navbar para insertar el botón de admin');
                    }
                }
            }
        } catch (err) {
            console.error('Error parsing user from localStorage', err);
        }
    }
    setupAdminButton();
});
