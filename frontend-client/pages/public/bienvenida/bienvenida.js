/* bienvenida.js */
$(function(){
  // Redirección simulada
  $('#btn-login, #btn-register, .ver-receta').on('click', function(){
    window.location.href = '../login/InicioDeSesion.html';
  });
});
