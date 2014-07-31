# Plugin should support Redmine 1.x and 2.x becuse guidelines were followed from: http://www.redmine.org/boards/3/topics/31445 
# Support for 1.x has not yet been confirmed. Any takers?

# Patches to the Redmine core.
require 'dispatcher' unless Rails::VERSION::MAJOR >= 3

if Rails::VERSION::MAJOR >= 3
  ActionDispatch::Callbacks.to_prepare do
    require_dependency 'redmine_incoming_emails/patches/mail_handler_patch'
  end
else
  Dispatcher.to_prepare :redmine_incoming_emails do
    require_dependency 'redmine_incoming_emails/patches/mail_handler_patch'
  end
end

# Plugin Definition
Redmine::Plugin.register :redmine_incoming_emails do
  name 'Incoming Emails plugin'
  author 'Mark Whitfeld'
  description 'This is a plugin for Redmine that allows for the configuration of the default project used when a user logs a new issue using email.'
  version '0.0.1'
  url 'https://github.com/markwhitfeld/redmine_incoming_emails'
  author_url 'https://github.com/markwhitfeld/redmine_incoming_emails'
  
  # See note at top of file regarding support for 1.x
  requires_redmine :version_or_higher => '2.0.0'
  
  settings(:partial => 'settings/incoming_emails_settings',
           :default => {} )
end
