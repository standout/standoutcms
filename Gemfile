source 'http://rubygems.org'

gem 'rails', '4.0.2'

gem "airbrake"
gem 'libv8'
gem 'awesome_nested_set'
gem 'aws-s3'
gem 'aws-sdk'
gem 'best_in_place', git: 'git://github.com/aaronchi/best_in_place.git'
gem "cancan"
gem 'capistrano', '~> 3.2.1'
gem 'capistrano-rails', '~> 1.1.1'
gem 'capistrano-unicorn-nginx', '~> 2.0.0'
gem 'ckeditor', :git => 'git://github.com/galetahub/ckeditor.git'
gem 'delayed_job_active_record'
gem 'delayed_job_web'
gem 'ace-rails-ap'
gem 'daemons'
gem 'dibs_hmac', '~> 0.1.2'
gem 'nokogiri'
gem 'execjs'
gem 'fileutils'
gem 'figaro'
gem 'gravtastic'
gem 'hpricot'
gem 'jquery-rails', '>= 1.0.12'
gem 'jquery-ui-rails'
gem 'liquid'
gem "mysql2"
gem "paperclip", ">= 2.0"
gem 'unicorn', '~> 4.8.3'
gem 'puma'
gem 'responders'
gem 'slim-rails'
gem "version"
gem "active_model_serializers", "~> 0.8.0"
gem 'angularjs-rails'

# Uploading multiple files at once
gem 'jquery-fileupload-rails'
gem 'delayed_paperclip'

# In order to use rails 4 assets with digest in production environment
# galetahub/ckeditor/tree/9e35addb42b42c7d520bbb579ecdb3d89d6a5847#usage-with-rails-4-assets
gem 'non-stupid-digest-assets', '~> 1.0.4'

# Vestal Versions can be found in many versions on Github. This one works
# with Rails 3 and also fixes a bug with 'alias_table_name' that is not
# already implemented in the main repository.
gem 'vestal_versions', :git => 'git://github.com/ericgoodwin/vestal_versions.git', branch: 'rails4'
gem 'will_paginate'
gem 'therubyracer'
gem 'remotipart', '>= 1.0.1'
gem "letter_opener", :group => :development
gem "httpclient"

# FROM PLUGINS
gem "query_reviewer", :git => "git://github.com/nesquena/query_reviewer.git"
gem "acts_as_list"
gem "acts_as_tree"
gem "responds_to_parent"
#gem "svn"

# JSON rendering
gem 'rabl'
gem 'oj'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'rake', '>= 0.9.6'
  gem 'spring'
  gem "nifty-generators"
  gem 'guard'
  gem 'terminal-notifier-guard'
  gem 'rb-fsevent', :require => false # if RUBY_PLATFORM =~ /darwin/i
  # Use Minitest with Spec syntax for testing
  gem 'minitest-spec-rails'
  # Use factories instead of fixtures when testing
  gem 'factory_girl_rails'
  gem 'guard-minitest'
  gem 'byebug'
  gem 'sqlite3'
  gem 'tinder'
  gem 'faker'
end

gem "bcrypt-ruby", :require => "bcrypt"
gem "mocha", require: false, group: :test

group :development do
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  # gem "rb-readline"
end

# Add rake db:dump, rake db:restore and cap db:pull
gem 'rails_db_dump_restore', '~> 0.0.4'
