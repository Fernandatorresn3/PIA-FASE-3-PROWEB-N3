//AQUI ACABA PANEL//

const comenatariosPendientes = $("#comentariosPendientes");
const usuariosActivos = $("#UsuariosActivos");
const recetasSemana = $("recetasemana")

  const token = localStorage.getItem("token");

  //Nuevos comentarios pendientes//
  $.ajax({
    url: "...",
    type: "GET",
    headers:
    {
      "Authorization": "Bearer " + token
    },
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
    url:"....",
    type: "GET",
    headers:
    {
      "Authorization": "Bearer" + token
    },

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



