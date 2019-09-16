require_dependency 'mail_handler'

module IncomingEmails
  module Patches
    module MailHandlerPatch
      def self.included(base) # :nodoc:
        base.extend(ClassMethods)

        # sending instance methods to module
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable
          
          alias_method :target_project_without_user_specific_defaults, :target_project
          alias_method :target_project, :target_project_with_user_specific_defaults
        end
      end

      module ClassMethods
      end

      module InstanceMethods
        def target_project_with_user_specific_defaults
          targetProjectId = Setting.plugin_redmine_incoming_emails[user.mail].to_i
          target = Project.find(targetProjectId) if targetProjectId > 0
          target = target_project_without_user_specific_defaults if target.nil?
          return target
        end
      end
    end
  end
end

# Include the module if it is not already included
unless MailHandler.included_modules.include? IncomingEmails::Patches::MailHandlerPatch
    MailHandler.send(:include, IncomingEmails::Patches::MailHandlerPatch)
end