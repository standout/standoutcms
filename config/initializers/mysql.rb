require 'active_record/connection_adapters/abstract_adapter'
module ActiveRecord
  module ConnectionAdapters
    class MysqlAdapter < AbstractAdapter
      def create_table(table_name, options = {}) #:nodoc:
        encoding = @config[:encoding]
        if encoding
          options = options.reverse_merge(:options => "DEFAULT CHARSET=#{encoding}")
        end
        super(table_name, options.reverse_merge(:options => "ENGINE=InnoDB"))
      end
    end
  end
end