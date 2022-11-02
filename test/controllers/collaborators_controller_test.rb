require "test_helper"

class CollaboratorsControllerTest < ActionDispatch::IntegrationTest
  test "should get collab_requests" do
    get collaborators_collab_requests_url
    assert_response :success
  end
end
