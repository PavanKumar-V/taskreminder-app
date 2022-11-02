$(document).ready(function () {
  $(document).on("click", "#popup-toggler", function (e) {
    e.stopPropagation();
    var popupmenu = $(this).parent().children(".popup-menu");
    popupmenu.toggle();
  });

  $(document).on("click", "body", function () {
    console.log("body");
    $(".popup-menu").hide(); //hide modal
  });

  $(".selectable").on("click", function (e) {
    e.stopPropagation();
    $(".selectable").removeClass("selected");
    $(this).addClass("selected");
    console.log($("#avatar-btn"));
    $("#avatar-btn").attr("href", `/users/edit/avatar/${$(this).attr("id")}`);
  });

  $("#close").on("click", function () {
    $(this).parent().remove();
  });
});
