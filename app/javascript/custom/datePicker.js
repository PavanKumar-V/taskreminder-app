jQuery(function () {
  var optional_config;
  optional_config = {
    enableTime: "true",
    allowInput: false, // if doesn't need - disable it.
    dateFormat: "M d, Y h:i K",
    defaultDate: "today",
  };


  $(".date-picker").flatpickr(optional_config);
});
