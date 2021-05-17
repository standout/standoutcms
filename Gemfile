# frozen_string_literal: true

source 'http://rubygems.org'

gem 'rails', '4.2.11.1'

gem 'ace-rails-ap'
gem 'active_model_serializers', '~> 0.8.0'
gem 'airbrake', '~> 4.3.4'
gem 'angularjs-rails'
gem 'awesome_nested_set'
gem 'aws-sdk', '~> 1'
gem 'aws-sdk-resources', '~> 2'
gem 'best_in_place', github: 'widernet/best_in_place', branch: 'rails-4'
gem 'cancan'
gem 'capistrano', '~> 3.4'
gem 'capistrano-rails', '~> 1.1.1'
gem 'capistrano-rbenv', '~> 2.1'
gem 'capistrano-unicorn-nginx', '~> 2.0.0'
gem 'ckeditor', git: 'git://github.com/galetahub/ckeditor.git'
gem 'daemons'
gem 'delayed_job_active_record'
gem 'delayed_job_web'
gem 'dibs_hmac', '~> 0.1.2'
gem 'execjs'
gem 'figaro', '>= 1.0.0'
gem 'gravtastic'
gem 'hpricot'
gem 'jquery-rails', '>= 1.0.12'
gem 'jquery-ui-rails', '~> 4.2.1'
gem 'libv8'
gem 'liquid', '~> 3.0.5 '
gem 'mysql2', '~> 0.3.18'
gem 'nokogiri', '~>1.11.4'
gem 'paperclip', '~> 5.2.0'
gem 'puma'
gem 'responders'
gem 'slim-rails'
gem 'sprockets-rails', '2.3.3'
gem 'unicorn', '~> 4.8.3'
gem 'version'
gem 'whenever'

# Uploading multiple files at once
gem 'delayed_paperclip'
gem 'jquery-fileupload-rails'

# In order to use rails 4 assets with digest in production environment
# galetahub/ckeditor/tree/9e35addb42b42c7d520bbb579ecdb3d89d6a5847#usage-with-rails-4-assets
gem 'non-stupid-digest-assets', '~> 1.0.4'

# Vestal Versions can be found in many versions on Github. This one works
# with Rails 3 and also fixes a bug with 'alias_table_name' that is not
# already implemented in the main repository.
gem 'httpclient'
gem 'letter_opener', group: :development
gem 'remotipart', '>= 1.0.1'
gem 'therubyracer'
gem 'vestal_versions', git: 'git://github.com/safetypins/vestal_versions.git', branch: 'rails_4_2'
gem 'will_paginate'

# FROM PLUGINS
gem 'acts_as_list'
gem 'acts_as_tree'
gem 'query_reviewer', git: 'git://github.com/nesquena/query_reviewer.git'
gem 'responds_to_parent'
# gem "svn"

# JSON rendering
gem 'oj'
gem 'rabl'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
end

# Gems used only for assets, should resolve issue
gem 'coffee-rails'
gem 'uglifier'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'guard'
  gem 'nifty-generators'
  gem 'rake', '>= 0.9.6'
  gem 'rb-fsevent', require: false # if RUBY_PLATFORM =~ /darwin/i
  gem 'spring'
  gem 'terminal-notifier-guard'
  # Use Minitest with Spec syntax for testing
  gem 'minitest-spec-rails'
  # Use factories instead of fixtures when testing
  gem 'byebug'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'guard-minitest'
  gem 'sqlite3'
  gem 'tinder'
end

gem 'bcrypt', require: 'bcrypt'
gem 'mocha', require: false, group: :test

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'thin'
  # gem "rb-readline"
end

# Add rake db:dump, rake db:restore and cap db:pull
gem 'rails_db_dump_restore', '~> 0.0.4'
