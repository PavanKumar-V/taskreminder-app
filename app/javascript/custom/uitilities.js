$(document).ready(function () {
  $(document).on("click", "#popup-toggler", function (e) {
    e.stopPropagation();
    var popupmenu = $(this).parent().parent().children(".popup-menu");
    popupmenu.toggle();
  });

  $(document).on("click", "body", function () {
    console.log("body");
    $(".popup-menu").hide(); //hide modal
  });

  var optional_config = {
    enableTime: "true",
    dateFormat: "d-m-Y h:i K",
  };

  $(".date-picker").flatpickr(optional_config);
});
