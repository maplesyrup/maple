require 'test_helper'

class LogEntriesControllerTest < ActionController::TestCase

  test "save record" do

    post :create, :log_entry => {
      :additt_version => "1.0",
      :android_build => "JellyBean",
      :time => "Mon May 04 09:51:52 PST 2009",
      :stack_trace => "Oh shit! Shit is messed up",
      :ad_creation_log => "Houston we have a problem"
    }

    log_entry_json = JSON.parse(response.body)

    assert log_entry_json
    assert_equal log_entry_json["additt_version"], "1.0"
    assert_equal log_entry_json["android_build"], "JellyBean"
    assert_equal log_entry_json["stack_trace"], "Oh shit! Shit is messed up"
    assert_equal log_entry_json["ad_creation_log"], "Houston we have a problem"
    assert_equal log_entry_json["time"], "Mon May 04 09:51:52 PST 2009"
  end
end
