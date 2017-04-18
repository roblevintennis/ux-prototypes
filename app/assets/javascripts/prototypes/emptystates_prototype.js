$( document ).ready(function() {
  $(".load.one").addClass("loaded");
  document.getElementById("my-btn").addEventListener("click", function(){
    $(".load.one").addClass("hide");
    $(".load.two").addClass("loaded");
  });
  document.getElementById("my-btn-too").addEventListener("click", function(){
    $(".load.two").addClass("hide");
    $(".load.three").addClass("loaded");
  });
  document.getElementById("onboard-one").addEventListener("click", function(){
    $("#onboard-one").addClass("left");
    $("#onboard-two").addClass("left");
  });
  document.getElementById("onboard-two").addEventListener("click", function(){
    $("#onboard-two").addClass("left-more");
    $("#onboard-three").addClass("left");
    $(".onboard-top").addClass("taller");
  });
});
