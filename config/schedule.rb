# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Process all images with thumbs not uploaded to s3, every minute.
every 1.minute do 
  runner "Picture.process_all"
end

every 1.day do 
  command 'cat /dev/null > /u/apps/standoutcms/shared/log/production.log'
end

# Learn more: http://github.com/javan/whenever
