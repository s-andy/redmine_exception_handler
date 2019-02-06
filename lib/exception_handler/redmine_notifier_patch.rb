module ExceptionHandler
  module RedmineNotifierPatch
    def self.included(target)
      target.send(:extend, ClassMethods)
      target.class_eval do
        class << self
          alias_method_chain :notify_exception, :database
        end
      end
    end

    module ClassMethods

      def notify_exception_with_database(exception, options = {})
        settings = Setting.plugin_redmine_exception_handler
        options[:exception_recipients] = settings['exception_handler_recipients'].split(',').map(&:strip)
        options[:sender_address] = settings['exception_handler_sender_address']
        options[:email_prefix] = settings['exception_handler_prefix']
        options[:email_format] = (settings['exception_handler_email_format'] || 'text').to_sym
        notify_exception_without_database(exception, options)
      end

    end

  end
end
