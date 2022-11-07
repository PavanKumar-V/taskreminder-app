$(document).ready(function () {
  $(document).on("click", "#popup-toggler", function (e) {
    e.stopPropagation();
    var popupmenu = $(this).parent().children(".popup-menu");
    popupmenu.toggle();
  });

  $(document).on("click", "body", function () {
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

  // sidebar right
  $("#sidebar-toggler").on("click", function (e) {
    $(".sidebar-right").addClass("sidebar-active");
  });

  $("#sidebar-closer").on("click", function (e) {
    $(".sidebar-right").removeClass("sidebar-active");
  });

  // add email
  $("#add-email-input").on("click", function () {
    var html = `
  <div class="input_field flex f-center mt-1 pos-rel">
        <input type="email" name="collab[emails][]" class="collab-email-input" id="collab[emails]" placeholder="email">
        <span class="material-symbols-outlined p-1 rounded-sm bg-err text-w ml-2 cursor-p" id="remove-email-input">
          remove
        </span>
      </div>
  `;
    $(this).parent().parent().append(html);
  });

  // mark email remove
  $(document).on("click", "#mark-remove-email", function (e) {
    var parent = $(this).parent();
    var collabEmail = parent.children("input[type=email]");
    collabEmail.addClass("border-danger");
    collabEmail.attr("name", "collab[remove_emails][]");
    collabEmail.attr("id", "collab[remove_emails]");
    var html = `
    <span class="material-symbols-outlined cursor-p ml-2 text-success" id="undo-remove">
      undo
    </span>
    `;
    parent.append(html);
    $(this).remove();
  });

  //  remove from mark
  $(document).on("click", "#undo-remove", function (e) {
    e.stopPropagation();
    console.log("this");
    var parent = $(this).parent();
    var collabEmail = parent.children("input[type=email]");
    var undoIcon = parent.children("#undo-remove");
    collabEmail.removeClass("border-danger");
    collabEmail.attr("name", "collab[existing_emails][]");
    collabEmail.attr("id", "collab[existing_emails]");
    undoIcon.remove();
    var html = `
    <span class="material-symbols-outlined rounded p-sm bg-err text-w ml-2 cursor-p text-md" id="mark-remove-email">
    person_remove
  </span>
    `;

    parent.append(html);
  });

  // remove email
  $(document).on("click", "#remove-email-input", function () {
    $(this).parent().remove();
  });

  // email input
  $(document).on("keyup", ".collab-email-input", function () {
    const parent = $(this).parent();
    if ($(this).val() == "") {
      parent.children(".emails").remove();
    }

    $.ajax({
      type: "GET",
      url: `/collab/emails/${$(this).val().toLowerCase()}`,
      success: function (res) {
        console.log(res);
        parent.children(".emails").remove();
        var html = `
        <div class="emails pos-abs bg-w p-1 rounded-md shadow" style="left:0 ; top: 40px;">
        `;
        $.each(res.emails, function (index, value) {
          html += ` <p class="text-sm p-sm cursor-p" id="email-select">${value.email}</p>`;
        });
        html += `
        </div>
        `;
        parent.append(html);
      },
    });
  });

  $(document).on("click", "#email-select", function () {
    console.log("hye");
    var parent = $(this).parent();
    parent.parent().children("input[type=email]").val($(this).text());
    parent.remove();
  });
});
