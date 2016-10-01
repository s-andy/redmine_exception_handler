require 'redmine'

Redmine::Plugin.register :redmine_exception_handler do
  name 'Redmine Exception Handler plugin'
  author 'Eric Davis'
  description 'Send emails when exceptions occur in Redmine.'
  version ExceptionHandler::VERSION.to_s
  requires_redmine :version_or_higher => '2.5.0'

  settings :default => {
    'exception_handler_recipients' => 'you@example.com, another@example.com',
    'exception_handler_sender_address' => 'Application Error <redmine@example.com>',
    'exception_handler_prefix' => '[ERROR] ',
    'exception_handler_email_format' => 'text'
  }, :partial => 'settings/exception_handler_settings'

end

require_dependency 'exception_notification'
require_dependency 'exception_notifier'
ExceptionNotifier.send(:include, ExceptionHandler::RedmineNotifierPatch)

RedmineApp::Application.config.middleware.use ExceptionNotification::Rack,
  :email => {
    :sections => %w(request session environment backtrace)
  }
