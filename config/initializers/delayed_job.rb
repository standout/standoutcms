# Added to avoid common problem of delayed job
# https://github.com/collectiveidea/delayed_job/wiki/Common-problems
# ActiveRecord::Base.send(:attr_accessible, :priority)
# ActiveRecord::Base.send(:attr_accessible, :payload_object)

# Don't destroy failed jobs
Delayed::Worker.destroy_failed_jobs = false 