$( document ).ready(function() {

  // App.registerPages({
  //   setup: setup,
  //   compare: showCompare,
  //   modal: showModal
  // });

  function isFirstProfileIcon(ev) {
    const x = ev.clientX;
    const y = ev.clientY;
    return (x > 490 && x < 540 && y > 220 && y < 255);
  }

  function isSecondProfileIcon(ev) {
    const x = ev.clientX;
    const y = ev.clientY;
    return (x > 490 && x < 540 && y > 260 && y < 300);
  }

  $(".master-planning").on("click", function(ev) {
    console.log("x: " + ev.clientX);
    console.log("y: " + ev.clientY);

    if(isFirstProfileIcon(ev)) {
      console.log("FIRST icon .. DO ZOOM IN")
    }

    if(isSecondProfileIcon(ev)) {
      console.log("Second icon .. DO SLIDE IN FROM Corner")
    }

  });

});
