$( document ).ready(function() {

  // App.registerPages({
  //   setup: setup,
  //   compare: showCompare,
  //   modal: showModal
  // });

  function isFirstProfileIcon(self, ev) {
    const offset = $(self).offset();
    const relativeX = (ev.pageX - offset.left);
    const relativeY = (ev.pageY - offset.top);
    // console.log("X: " + relativeX + "  Y: " + relativeY);
    return (relativeX > 300 && relativeX < 360 && relativeY > 310 && relativeY < 350);
  }

  function isSecondProfileIcon(self, ev) {
    const offset = $(self).offset();
    const relativeX = (ev.pageX - offset.left);
    const relativeY = (ev.pageY - offset.top);
    // console.log("X: " + relativeX + "  Y: " + relativeY);
    return (relativeX > 300 && relativeX < 360 && relativeY > 360 && relativeY < 400);
  }

  function reset() {
      $('.master-planning').removeClass('ghosted');
      $('.resource-picker').addClass('hidden').removeClass('zoom-in corner-right');
  }

  $(document).keyup(function(e) {
    if (e.keyCode == 27) { // escape key maps to keycode `27`
      reset();
    }
  });

  $(".master-planning").on("click", function(ev) {
    $('.master-planning').addClass('ghosted');

    if(isFirstProfileIcon(this, ev)) {
      $('.resource-picker').removeClass('hidden').addClass('zoom-in');
    }

    if(isSecondProfileIcon(this, ev)) {
      $('.resource-picker').removeClass('hidden').addClass('corner-right');
    }
  });

});
