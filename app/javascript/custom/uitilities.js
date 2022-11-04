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

  // add email
  $("#add-email-input").on("click", function () {
    var html = `
  <div class="input_field flex f-center mt-1">
        <input type="email" name="collab[email][]" class="collab-email-input" id="collab[email]" placeholder="email">
        <span class="material-symbols-outlined p-1 rounded-sm bg-err text-w ml-2 cursor-p" id="remove-email-input">
          remove
        </span>
      </div>
  `;
    $(this).parent().parent().append(html);
  });

  // remove email
  $(document).on("click", "#remove-email-input", function () {
    $(this).parent().remove();
  });

  $(document).on("keyup", ".collab-email-input", function () {
    const parent = $(this).parent()
    $.ajax({
      type: "GET",
      url: `/collab/emails/${$(this).val().toLowerCase()}`,
      success: function (res) {
        console.log(res);
        parent.child(".emails").remove()
        var html = `
        <div class="emails pos-abs bg-w p-1 rounded-md shadow" style="left:0 ; top: 40px;">
        `;
        $.each(res.emails, function (key, email) {
          html += ` <p class="text-sm p-sm">${email}</p>`;
        });
        html += `
        </div>
        `;
        parent.append(html);
      },
    });
  });
});
