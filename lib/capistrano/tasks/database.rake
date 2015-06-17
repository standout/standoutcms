namespace :database do
  require 'yaml'

  def config
    @config ||= YAML.load_file("config/database.yml")
  end

  def time
    Time.now.utc.strftime('%Y%m%d%H%M%S')
  end

  desc "Dump database"
  task :dump do
    dump = "/usr/bin/mysqldump"
    backup = "#{deploy_to}/backup"
    db = config['production']['database']
    us = config['production']['username']
    pw = config['production']['password']
    on roles(:db) do
      execute "#{dump} -u #{us} -p#{pw} -B #{db} > #{backup}/production.sql"
      execute "cp #{backup}/production.sql #{backup}/production-#{time}.sql"
    end
  end

end
