$(document).ready(function ()
{
 const path = window.location.pathname.split("/").pop();

$(".nav-link").each(function ()
{
  const href = $(this).attr("href");

  if (href === path)
  {
    $(this).addClass("active-link");
  } else{
    $(this).removeClass("active-link");
  }
});
});