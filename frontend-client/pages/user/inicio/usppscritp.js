$(document).ready(function() {

    const apiBase = 'http://localhost:8080/api';
    const userId = 1; 

    let currentPage = 0;
    const pageSize = 10;
    
    let busqueda = '';
    let categoria = '';

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

    // Cargar categorías
    function loadCategories() {
        $.ajax({
            url: `${apiBase}/categories`,
            type: 'GET'
        }).done(function(data) {
            const $categoryFilter = $('#categoryFilter');
            data.forEach(cat => {
                $categoryFilter.append(`<option value="${cat.id}">${cat.nombre}</option>`);
            });
        }).fail(function(xhr) {
            console.error('Error cargando categorías', xhr);
        });
    }

    // Cargar recetas
    function loadRecipes() {
        $.ajax({
            url: `${apiBase}/recipes`,
            type: 'GET',
            data: {
                page: currentPage,
                size: pageSize,
                busqueda: busqueda,
                categoria: categoria
            }
        }).done(function(data) {
            const $recipesGrid = $('#recipesGrid');
            $recipesGrid.empty();

            if (!data || data.length === 0) {
                $recipesGrid.append('<p class="text-center">No se encontraron recetas.</p>');
                return;
            }

            data.forEach(recipe => {
                const imageFile = recipe.imagenUrl ? recipe.imagenUrl.split('/').pop() : '';
                const imageUrl = imageFile ? `${apiBase}/files/images/${imageFile}` : 'placeholder.jpg';

                const isDestacada = recipe.destacadaPorUsuario; 
                const starColor = isDestacada ? 'gold' : 'gray';

                const card = `
                <div class="col-md-4">
                    <div class="card h-100 shadow-sm">
                        <img src="${imageUrl}" class="card-img-top" alt="${recipe.titulo}">
                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title">${recipe.titulo}</h5>
                            <p class="card-text mb-1">Calificación: ${recipe.calificacionPromedio || 0} (${recipe.totalCalificaciones || 0} opiniones)</p>
                            <div class="mt-auto d-flex justify-content-between align-items-center">
                                <i class="bi bi-star fs-4 star-icon" data-id="${recipe.id}" style="cursor:pointer;color:${starColor};"></i>
                                <button class="btn btn-primary btn-sm view-recipe-btn" data-id="${recipe.id}">
                                    <i class="bi bi-eye"></i> Ver receta
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                `;
                $recipesGrid.append(card);
            });
        }).fail(function(xhr) {
            console.error('Error cargando recetas', xhr);
            $('#recipesGrid').html('<p class="text-center text-danger">Error cargando recetas.</p>');
        });
    }

    // Destacar receta 
    $(document).on('click', '.star-icon', function() {
        const $icon = $(this);
        const recipeId = $icon.data('id');
        const token = localStorage.getItem('token');

        const isHighlighted = $icon.css('color') === 'rgb(255, 215, 0)'; // 

        if (!isHighlighted) {
            // destacar
            $.ajax({
                url: `${apiBase}/profile/favorites/${recipeId}`,
                type: 'POST',
                headers: { 'Authorization': 'Bearer ' + token }
            }).done(function() {
                $icon.css('color', 'gold');
            }).fail(function() {
                alert('No se pudo destacar la receta.');
            });
        } else {
            // Quitar destacado
            $.ajax({
                url: `${apiBase}/profile/favorites/${recipeId}`,
                type: 'DELETE',
                headers: { 'Authorization': 'Bearer ' + token }
            }).done(function() {
                $icon.css('color', 'gray');
            }).fail(function() {
                alert('No se pudo quitar el destacado.');
            });
        }
    });

    // Ver receta
    $(document).on('click', '.view-recipe-btn', function() {
        const recipeId = $(this).data('id');
        window.location.href = `../detalle-receta/DetalleDeReceta.html?id=${recipeId}`;
    });

    // Búsqueda y filtrado
    $('#serachInput').on('input', function() {
        busqueda = $(this).val();
        currentPage = 0;
        loadRecipes();
    });


    $('#categoryFilter').on('change', function() {
        categoria = $(this).val();
        currentPage = 0;
        loadRecipes();

    });

    $('#prevPageBtn').on('click', function() {
        if (currentPage > 0) {
            currentPage--;
            loadRecipes();
        }
    });

    $('#nextPageBtn').on('click', function() {
        currentPage++;
        loadRecipes();
    });

    //LOGOUT
    $('#logoutBtn').on('click', function(e) {
        e.preventDefault();
        const token = localStorage.getItem('token');
    
        $.ajax({
            url: `${apiBase}/auth/logout`,
            type: 'POST',
            headers: { 'Authorization': 'Bearer ' + token }
        }).always(function() {
            localStorage.removeItem('token');
            localStorage.removeItem('user');
            window.location.href = '../../public/login/InicioDeSesion.html';
        });
    });


    // Insert admin button if applicable, then load categories and recipes
    setupAdminButton();
    loadCategories();
    loadRecipes();

});
