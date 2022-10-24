jQuery(function () {
  // var optional_config;

 const fp =  $(".date-picker").flatpickr({
    enableTime: "true",
    allowInput: false,
    dateFormat: "M d, Y h:i K",
    defaultDate: [new Date()],
  });

  $(".date-picker").on('click', function () {
    fp.setDate(new Date(`${$(this).attr("data-id")}`), "", "")
   })

  $(".date-picker-calendar").flatpickr({
    allowInput: false, // if doesn't need - disable it.
    defaultDate: "today",
    enableTime: false,
    inline: true,
    dateFormat: "Y-m-d",
  });

  $(".date-picker-calendar").on("change", function (e) {
    var date = $(this).val();
    var link_to = $(this).parent().parent().find("a#get-tasks");
    link_to.attr("href", `/tasks/date/${date}`);
    console.log(link_to.attr("href"));
  });
});
