Zaglushka::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  #config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  #config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true
 # ActionMailer Config

  # to have absolute URLs for images and links in emails
  config.action_mailer.default_url_options = {
    :host       => Settings.mailer.host,
    :protocol   => 'http',
    :port       => Settings.mailer.rails_port
  }
  config.action_mailer.asset_host = 'http://followmytravel.com'
  config.action_mailer.delivery_method = :test
  # change to true to allow email to be sent during development
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default :charset => "utf-8"
  config.action_mailer.smtp_settings = {
    address:              Settings.mailer.address,
    port:                 Settings.mailer.port,
    domain:               Settings.mailer.domain,
    authentication:       Settings.mailer.authentication,
    enable_starttls_auto: Settings.mailer.enable_starttls_auto,
    user_name:            Settings.mailer.user_name,
    password:             Settings.mailer.password
  }

end
