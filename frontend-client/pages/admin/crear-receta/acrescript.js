$(document).ready(function (){

 const path = window.location.pathname.split("/").pop().toLowerCase();

$(".sidebar nav .nav-link").each(function ()
{
  const href = $(this).attr("href").split("/").pop().toLowerCase();

  if (href === path)
  {
    $(this).addClass("active-link");
  } else{
    $(this).removeClass("active-link");
  }
});
});

//CARGAR CATEGORIAS PARA FORMUALRIO//
$(document).ready(function() {
  // Si viene ?edit=id en la URL, cargar la receta para edición
  const params = new URLSearchParams(window.location.search);
  const editId = params.get('edit');
  if (editId) {
    // Obtener datos de la receta (endpoint público)
    fetch(`http://localhost:8080/api/recipes/${editId}`)
      .then(res => res.json())
      .then(recipe => {
        // Rellenar formulario con los campos esperados
        $('#recipeName').val(recipe.titulo || recipe.title || '');
        $('#shortDescription').val(recipe.descripcion || recipe.description || '');
        $('#countryOrigin').val(recipe.paisOrigen || '');
        $('#category').val(recipe.categoriaId || recipe.categoriaId || '');
        $('#ingredients').val(recipe.ingredientes || '');
        // instrucciones puede venir como JSON array o texto
        if (Array.isArray(recipe.instrucciones)) {
          $('#steps').val(recipe.instrucciones.join('\n'));
        } else {
          $('#steps').val(recipe.instrucciones || '');
        }

        // Marcar el formulario en modo edición
        $('#submitBtn').text('Actualizar receta');
        $('#newRecipeForm').data('editId', editId);
      })
      .catch(err => console.error('Error cargando receta para editar:', err));
  }

    // Cargar categorías en el select (admin)
    function loadCategories() {
        $.ajax({
            url: 'http://localhost:8080/api/admin/categories',
            type: 'GET',
            headers: {
                'Authorization': 'Bearer ' + localStorage.getItem('token')
            }
        })
        .done(function(data) {
            console.log("Categorías obtenidas:", data); // debug
            const $categorySelect = $('#category');
            $categorySelect.empty();
            $categorySelect.append('<option value="">Seleccione una categoría</option>');
            data.forEach(cat => {
                $categorySelect.append(`<option value="${cat.id}">${cat.nombre}</option>`);
            });
        })
        .fail(function(xhr, status, error) {
    console.error("Error al cargar categorías:");
    console.log("Status:", status);
    console.log("Error:", error);
    console.log("XHR response:", xhr.responseText);
});

    }

    loadCategories();
});


 //BOTON CANCELAR
 $('#cancelBtn').click(function(){
  $('#newRecipeForm')[0].reset();
 });

 //BOTON GUARDAR 
 $('#newRecipeForm').submit(function (e){
  e.preventDefault();

  const newRecipe = {
    titulo: $('#recipeName').val(),
    descripcion: $('#shortDescription').val(),
    paisOrigen: $('#countryOrigin').val(),
    categoriaId: $('#category').val(),
    ingredientes: $('#ingredients').val(),
    instrucciones: $('#steps').val(),
  };
  // Si hay archivo seleccionado, subir primero y luego crear receta con imagenUrl
  const file = $('#imageInput')[0] && $('#imageInput')[0].files[0];

  function sendRecipe(payload) {
    $.ajax({
      url: (function(){
          const editId = $('#newRecipeForm').data('editId');
          if (editId) return `http://localhost:8080/api/admin/recipes/${editId}`;
          return 'http://localhost:8080/api/admin/recipes';
      })(),
      type: (function(){
          return $('#newRecipeForm').data('editId') ? 'PUT' : 'POST';
      })(),
      headers: { 'Authorization': 'Bearer ' + localStorage.getItem('token') },
      contentType: 'application/json',
      data: JSON.stringify(payload)
    }).done(function (){
      alert("Receta guardada exitosamente");
      $('#newRecipeForm')[0].reset();
      if ($('#newRecipeForm').data('editId')) {
          $('#newRecipeForm').removeData('editId');
          location.href = '../gestionar-recetas/crindex.html';
      }
    }).fail(function () {
      alert("Error al guardar la receta");
    });
  }

  if (file) {
    var fd = new FormData();
    fd.append('file', file);
    $.ajax({
      url: 'http://localhost:8080/api/files/upload',
      type: 'POST',
      headers: { 'Authorization': 'Bearer ' + localStorage.getItem('token') },
      data: fd,
      processData: false,
      contentType: false
    }).done(function(res) {
      // response.filePath según API
      newRecipe.imagenUrl = res.filePath;
      sendRecipe(newRecipe);
    }).fail(function() {
      alert('Error al subir imagen');
    });
  } else {
    sendRecipe(newRecipe);
  }
 });

// Previsualización de imagen seleccionada
$('#imageInput').on('change', function() {
  const f = this.files && this.files[0];
  if (f) {
    const url = URL.createObjectURL(f);
    $('#imagePreview').attr('src', url).show();
  } else {
    $('#imagePreview').hide().attr('src', '');
  }
});