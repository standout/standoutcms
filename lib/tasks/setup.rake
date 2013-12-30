desc 'Bootstrap the application'
task :bootstrap do
  FileUtils.copy("#{Rails.root}/config/database.yml.example", "#{Rails.root}/config/database.yml")
  FileUtils.copy("#{Rails.root}/config/application.example.yml", "#{Rails.root}/config/application.yml")
  puts 'Bootstrapping done.'
end