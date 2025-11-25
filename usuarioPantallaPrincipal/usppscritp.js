$(document).ready(function() {

    const apiBase = 'http://localhost:8080/api';
    let currentPage = 0;
    const pageSize = 10;

    let busqueda = '';
    let categoria = '';

    // Función para cargar categorías en el dropdown
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

    // Función para cargar recetas
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

            if (data.length === 0) {
                $recipesGrid.append('<p class="text-center">No se encontraron recetas.</p>');
                return;
            }

            data.forEach(recipe => {
                const imageFile = recipe.imagenUrl ? recipe.imagenUrl.split('/').pop() : '';
                const imageUrl = imageFile ? `${apiBase}/files/images/${imageFile}` : 'placeholder.jpg';

                const card = `
                <div class="col-md-4">
                    <div class="card h-100 shadow-sm">
                        <img src="${imageUrl}" class="card-img-top" alt="${recipe.titulo}">
                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title">${recipe.titulo}</h5>
                            <p class="card-text mb-1">Calificación: ${recipe.calificacionPromedio || 0} (${recipe.totalCalificaciones || 0} opiniones)</p>
                            <div class="mt-auto d-flex justify-content-between align-items-center">
                                <i class="bi bi-star fs-4 star-icon" data-id="${recipe.id}" style="cursor:pointer;color:gray;"></i>
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

    // Evento para búsqueda
    $('#serachInput').on('input', function() {
        busqueda = $(this).val();
        currentPage = 0;
        loadRecipes();
    });

    // Evento para cambio de categoría
    $('#categoryFilter').on('change', function() {
        categoria = $(this).val();
        currentPage = 0;
        loadRecipes();
    });

    // Paginación
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

    // Evento para la estrella
    $(document).on('click', '.star-icon', function() {
        const $icon = $(this);
        const recipeId = $icon.data('id');

        // Cambiar color de la estrella
        if ($icon.css('color') === 'rgb(128, 128, 128)') { // gris
            $icon.css('color', 'gold');
        } else {
            $icon.css('color', 'gray');
        }

        // Aquí podrías enviar a API para marcar como destacado:
        // $.post(`${apiBase}/profile/favorites/${recipeId}`, ... )
        console.log('Receta destacada:', recipeId);
    });

    // Evento para ver receta
    $(document).on('click', '.view-recipe-btn', function() {
        const recipeId = $(this).data('id');
        // Redirigir a detalle de receta (pantalla que harás después)
        window.location.href = `recipe-detail.html?id=${recipeId}`;
    });

    // Inicialización
    loadCategories();
    loadRecipes();

});
