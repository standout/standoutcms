namespace :db do
  require 'yaml'

  def config
    @config ||= YAML.load_file("config/database.yml")
  end

  def time
    Time.now.utc.strftime('%Y%m%d%H%M%S')
  end

  desc "Dump database"
  task :mysqldump do
    dump = "/usr/bin/mysqldump"
    db = config['production']['database']
    us = config['production']['username']
    pw = config['production']['password']
    backup_to = "#{deploy_to}/backup"
    on roles(:app), in: :sequence do
      execute "#{dump} -u #{us} -p#{pw} -B #{db} > #{backup_to}/production.sql"
      execute "cp #{backup_to}/production.sql #{backup_to}/production-#{time}.sql"
    end
  end

end
