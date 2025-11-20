$(document).ready(function(){
  var path = window.location.pathname.split("/").pop();

  $(".nav-link").each(function(){
    var href = $(this).attr("href");

    if(href === path){
      $(this).addClass("active-link");
    } else {
      $(this).removeClass("active-link");
    }
  });
});
