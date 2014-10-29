namespace :db do 
  desc "Get production DB!"
  task :pull do 
    puts "Fetching remote database"
    sh 'cap production db:mysqldump'
    sh 'rm -rf db/production.sql && scp root@standoutcms.se:/u/apps/standoutcms/backup/production.sql db/production.sql'
    config = YAML.load_file("config/database.yml")
    dev_db = config["development"]
    user = dev_db["username"]
    pass = dev_db["password"]
    sh "mysql -u #{user} #{pass && "-p #{pass}"} < db/production.sql"
    puts "Finished."
  end
end

