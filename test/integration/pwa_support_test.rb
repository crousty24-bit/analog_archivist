require "test_helper"
require "json"

class PwaSupportTest < ActionDispatch::IntegrationTest
  test "layout references the manifest" do
    get new_user_session_path

    assert_response :success
    assert_includes @response.body, pwa_manifest_path(format: :json)
    assert_includes @response.body, 'rel="manifest"'
  end

  test "manifest is served as json" do
    get pwa_manifest_path(format: :json)

    assert_response :success
    assert_equal "application/json", response.media_type
    payload = JSON.parse(@response.body)

    assert_equal "The Analog Archivist", payload.fetch("name")
    assert_equal "standalone", payload.fetch("display")
  end

  test "service worker is served as javascript" do
    get pwa_service_worker_path(format: :js)

    assert_response :success
    assert_match(/javascript/, response.media_type)
    assert_includes @response.body, 'self.addEventListener("install"'
    assert_includes @response.body, "self.clients.claim()"
  end
end
