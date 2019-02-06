require File.expand_path("../../test_helper", __FILE__)

class RedmineExceptionHandlerTest < Redmine::IntegrationTest
  def test_exception
    assert_difference 'ActionMailer::Base.deliveries.size', 1 do
      get "/example_exception"
    end
    mail = ActionMailer::Base.deliveries.last
    settings = Setting.plugin_redmine_exception_handler
    assert_equal([
                   settings["exception_handler_recipients"],
                   settings["exception_handler_sender_address"],
                 ],
                 [
                   mail.to.join(", "),
                   mail.header["From"].value,
                 ])
  end
end
