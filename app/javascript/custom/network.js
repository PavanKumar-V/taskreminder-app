$(document).ready(async function () {
  async function get_avatar(avatar_id, element) {
    var result = "null";
    $.ajax({
      type: "GET",
      url: `/avatars/${avatar_id}`,
      success: function (res) {
        res = result;
      },
    });

    return result;
  }


});
