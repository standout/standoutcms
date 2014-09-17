ActionController::Base.send :include, RespondsToParent
require 'respond_to_parent/lib/responds_to_parent'

Rails.application.config.middleware.use JQuery::FileUpload::Rails::Middleware
