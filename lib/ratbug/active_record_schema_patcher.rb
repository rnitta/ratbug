require 'ratbug/active_record_schema_monkey'

module Ratbug
  module ActiveRecordSchemaPatcher
    refine ActiveRecord::Schema do
      class << ActiveRecord::Schema
        def define(**argh, &block)
          p argh
          monkey = ActiveRecordSchemaMonkey.new
          monkey.instance_eval(&block)
          monkey
        end
      end
    end
  end
end
