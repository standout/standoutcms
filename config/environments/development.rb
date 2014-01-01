StandoutCms::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.default_url_options = { :host => "standoutcms.dev" }

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  I18n.enforce_available_locales = false

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  config.secret_key_base = ENV['SECRET_KEY_BASE']

  config.assets.enabled = true
  config.assets.compress = false
  config.assets.debug = false

  config.eager_load = false

  config.autoload_paths += %W(#{config.root}/app/models/ckeditor)

  # New in rails 3.2
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Is set to :strict by default in 3.2 but not by us, yet:
  # ActiveModel::MassAssignmentSecurity::Error: Can't mass-assign protected attributes: default
  config.active_record.mass_assignment_sanitizer = :logger # Should be :strict but major failure
end

