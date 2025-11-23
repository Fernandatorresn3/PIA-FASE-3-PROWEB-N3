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