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
            console.error("Error al cargar categorías:", error);
            alert("No se pudieron cargar las categorías. Revisa la consola.");
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
    nombre: $('#recipeName').val(),
    descripcion: $('#shortDescription').val(),
    paisOrigen: $('#countryOrigin').val(),
    categoriaId: $('#category').val(),
    ingredientes: $('#ingredients').val(),
    pasos: $('#steps').val(),
  };

  $.ajax({
    url: 'http://localhost:8080/api/recipes',
    type: 'POST',
    headers: { 'Authorization': 'Bearer ' + localStorage.getItem('token') },
    contentType: 'application/json',
    data: JSON.stringify(newRecipe)
  }).done(function (){
    alert("Receta guardada exitosamente");
    $('#newRecipeForm')[0].reset();
  }).fail(function () {
    alert("Error al guardar la receta");
  });
 });