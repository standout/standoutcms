# Load the rails application
require File.expand_path('../application', __FILE__)

Dir["#{Rails.root}/lib/liquid_extensions/**/*.rb"].each { |f| require f }

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

# Initialize the rails application
StandoutCms::Application.initialize!
