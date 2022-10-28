require "application_system_test_case"

class AvatarsTest < ApplicationSystemTestCase
  setup do
    @avatar = avatars(:one)
  end

  test "visiting the index" do
    visit avatars_url
    assert_selector "h1", text: "Avatars"
  end

  test "should create avatar" do
    visit avatars_url
    click_on "New avatar"

    click_on "Create Avatar"

    assert_text "Avatar was successfully created"
    click_on "Back"
  end

  test "should update Avatar" do
    visit avatar_url(@avatar)
    click_on "Edit this avatar", match: :first

    click_on "Update Avatar"

    assert_text "Avatar was successfully updated"
    click_on "Back"
  end

  test "should destroy Avatar" do
    visit avatar_url(@avatar)
    click_on "Destroy this avatar", match: :first

    assert_text "Avatar was successfully destroyed"
  end
end
