require 'ratbug/table'

module Ratbug
  module ActiveRecordSchemaMonkeyExt
    def create_table(table_name, **, &block)
      table = Table.new(table_name)
      table.instance_exec(table, &block)
      @tables[table_name] = table
    end

    def enable_extension(*)
      # do nothing
    end

    def add_foreign_key(*)
      # do nothing
    end
  end

  class ActiveRecordSchemaMonkey
    attr_accessor :tables

    def initialize
      # {table_name: Table}
      @tables = Hash.new
    end

    private

    include ActiveRecordSchemaMonkeyExt

    def method_missing(symbol, *args)
      puts "ActiveRecord::Schema##{symbol.to_s}(#{args.join(', ')}) has no use currently"
    end
  end
end
