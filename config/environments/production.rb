StandoutCms::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"
  config.filter_parameters << :password

  config.eager_load = true

  config.secret_key_base = ENV['SECRET_KEY_BASE']

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = false
  config.assets.compress = true
  config.assets.js_compressor = :uglifier
  config.assets.digest = true
  config.assets.debug = false
  config.assets.precompile += Ckeditor.assets
  config.assets.precompile += [
    'scaffold.css',
    'websites_grid.css',
    'login.css',
    'jquery.js',
    'users.js',
    'admin.css',
    'custom_data_lists.css',
    'jquery.Jcrop.css',
    'jquery.ui.all.js',
    'jquery.ui.all.css',
    'ui-lightness/jquery-ui-1.8.10.custom.css',
    'websites.js',
    'websites.css',
    'looks.css',
    'code_editor.css',
    'page_templates.js',
    'page_templates.css',
    'pages.js',
    'pages.css',
    'look_files.js',
    'ckeditor/config.js',
    'ckeditor/skins/kama/editor.css',
    'ckeditor/skins/kama/dialog.css',
    'ckeditor/lang/en.js',
    'ckeditor/plugins/styles/styles/default.js',
    'ckeditor/plugins/embed/plugin.js',
    'ckeditor/plugins/embed/lang/en.js',
    'ckeditor/plugins/attachment/plugin.js',
    'ckeditor/plugins/attachment/lang/en.js',
  ]
  # config.assets.fingerprinting.exclude << "looks/*"

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { :host => "standoutcms.se" }

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

end

ActionMailer::Base.smtp_settings = {
  user_name: ENV["SMTP_USER_NAME"],
  password:  ENV["SMTP_PASSWORD"],
  :domain => "standoutcms.se",
  :address => "smtp.sendgrid.net",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}
