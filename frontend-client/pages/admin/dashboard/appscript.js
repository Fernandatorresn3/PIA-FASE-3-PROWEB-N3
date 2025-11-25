//AQUI ACABA PANEL//
$(docuemnt).ready(function () {

const comenatariosPendientes = $("#comentariosPendientes");
const usuariosActivos = $("#UsuariosActivos");
const recetasSemana = $("#recetassemana");

  const token = localStorage.getItem("token");
  const apiBase = "http://localhost:8080/api";

  //Carga de comentarios pendientes//
  $.ajax({
    url: `${apiBase}/admin/comments/pending`,
    type: "GET",
    headers:{ "Authorization": "Bearer " + token },
    success: function (data)
    {
      comentariosPendientes.text(data.length);
    },
    error: function ()
    {
      comentariosPendientes.text("Error");
    }
    
  });

  //Usuarios activos hoy| Recetas publicadas esta semana//

  $.ajax({
    url: `${apiBase}/admin/dashboard`,
    type: "GET",
    headers: { "Authorization": "Bearer " + token },
    success: function (data)
    {
      usuariosActivos.text(data.usuariosActivos);
      recetasSemana.text(data.recetasPublicadas);
    },
    error: function ()
    {
      usuariosActivos.text("Error");
      recetasSemana.text("Error");
    }

  });
});



