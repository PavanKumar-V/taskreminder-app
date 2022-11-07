jQuery(function () {
  // var optional_config;





  $(".date-picker").flatpickr({
    enableTime: "true",
    allowInput: false,
    dateFormat: "M d, Y h:i K",
  });

  var inlineCalendarDate = $("#cur-date").text();

  $(".date-picker-calendar").flatpickr({
    allowInput: false, // if doesn't need - disable it.
    defaultDate: inlineCalendarDate,
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

  var optional_config = {
    enableTime: "true",
    allowInput: false,
    dateFormat: "M d, Y h:i K",
  }

  var start_date = $(".start-date").val();
  var end_date = $(".end-date").val();

  console.log(start_date);
  $(".start-date").flatpickr({...optional_config, defaultDate: new Date(start_date)});
  $(".end-date").flatpickr({...optional_config, defaultDate: new Date(end_date)});
});
