require "bundler/capistrano"
load 'deploy/assets'

set :application, "standoutcms"
set :repository,  "git@github.com:standout/standoutcms.git"

set :default_environment, {
    'PATH' => "/usr/local/rbenv/shims:/usr/local/rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/rvm/bin"
}

set :scm, :git
set :branch, "master"
# set :deploy_via, :remote_cache
set :user, 'root'
set :runner, 'www-data'
set :git_enable_submodules, 1

role :app, "standoutcms.se"
role :web, "standoutcms.se"
role :db,  "standoutcms.se", :primary => true

desc "Dump database"
task :mysqldump, :roles => [:app] do
  run "/usr/bin/mysqldump -u yourdbuser -pyourpassword -B standoutcms > /u/apps/#{application}/backup/production.sql"
  run "cp /u/apps/#{application}/backup/production.sql /u/apps/#{application}/backup/production-#{Time.now.to_i}.sql"
end

before :deploy, "mysqldump"

after :deploy, "deploy:migrate"
after :deploy, "deploy:cleanup"
after :deploy, "deploy:dj"

set :keep_releases, 5

namespace :deploy do

  task :after_update_code, :roles => :app do
    run "rm -rf #{release_path}/public/.htaccess"
    run "ln -sf #{shared_path}/database.yml #{release_path}/config/database.yml"
  end

  task :dj, :roles => :app do
    run "cd #{current_path} && /usr/bin/env RAILS_ENV=production script/delayed_job stop"
    run "cd #{current_path} && /usr/bin/env RAILS_ENV=production script/delayed_job start"
  end

  # Make sure we have the correct permissions on everything
  task :after_symlink, :roles => :app do

    # For shared files
    run "mkdir -p #{shared_path}/files"
    run "rm -rf #{release_path}/public/files && ln -s #{shared_path}/files #{release_path}/public/files"
    #run "chown -R www-data:www-data #{shared_path}/files"
    run "chmod -R 777 #{shared_path}"

    #
    # # Link paperclip uploads to shared path
    # run "ln -sf #{shared_path} #{release_path}/public/system"
    #
    # Permissions
    run "chmod -R 755 #{current_path}/tmp"
    run "chown -R www-data:www-data #{current_path}/"
    run "chown -R www-data:www-data #{shared_path}/"

    # We need to restart Apache, because we are using imagescience
    run "sudo /etc/init.d/apache2 reload"

  end

  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end

Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end


require './config/boot'
require 'airbrake/capistrano'
