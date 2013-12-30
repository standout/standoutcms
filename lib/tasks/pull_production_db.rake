namespace :db do 
  desc "Get production DB!"
  task :pull do 
    puts "Fetching remote database"
    sh 'cap mysqldump'
    sh 'rm -rf db/production.sql && scp root@standoutcms.se:/u/apps/standoutcms/backup/production.sql db/production.sql'
    sh 'mysql -u standoutdev -pdev404 < db/production.sql'
    puts "Finished."
  end
end

