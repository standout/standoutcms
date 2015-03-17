# Monkey patch ActiveSupport::TimeWithZone to go back to the Rails 3.2
# implementation because of bug with milliseconds in json output
# TODO: Remove when upgrading to Rails 4.1
# Then we can just set ActiveSupport::JSON::Encoding.time_precision = 0 instead
# http://www.software-thoughts.com/2014/04/removing-milliseconds-in-json-under.html
# Google: rails test to_json milliseconds
module ActiveSupport
  class TimeWithZone
    def as_json(options = nil)
      if ActiveSupport::JSON::Encoding.use_standard_json_time_format
        xmlschema
      else
        %(#{time.strftime("%Y/%m/%d %H:%M:%S")} #{formatted_offset(false)})
      end
    end
  end
end
