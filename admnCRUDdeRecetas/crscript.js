$(document).ready(function ()
{
 const path = window.location.pathname.split("/").pop();

$(".nav-link").each(function ()
{
  const href = $(this).attr("href").split("/").pop();

  if (href === path)
  {
    $(this).addClass("active-linkl");
  } else{
    $(this).removeClass("active-link");
  }
});

});

//AQUI ACABA PANEL//




