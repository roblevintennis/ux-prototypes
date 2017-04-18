$( document ).ready(function() {
  $(".load.one").addClass("loaded");
  document.getElementById("my-btn").addEventListener("click", function(){
    $(".load.one").addClass("hide");
    $(".load.two").addClass("loaded");
  });
});
