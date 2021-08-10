require 'ratbug/active_record_schema_patcher'
require 'ratbug/generators/jbuilder_generator'
require 'ratbug/generators/typescript_generator'

module Ratbug
  class Runner
    class << self
      using Ratbug::ActiveRecordSchemaPatcher

      # @param [Array<String>] table_names
      # @param [GenerateConfig] options
      def execute(table_names, options)
        unless defined? Rails
          fail 'this gem is to be used in rails context'
        end
        # scan schema
        monkey = eval(File.open(Rails.root.join('db', 'schema.rb')).read)
        tables = monkey.tables.slice(*table_names)
        tables.values.each do |table|
          unless options[:use_only_schema]
            model = table_name_to_model(table.name, options[:table_name_to_model_converter])
            if model.present?
              table.load_enums(model)
              table.load_presence_validators(model)
            end
          end

          if options[:enabled_outputs].include?('jbuilder')
            Ratbug::Generators::JbuilderGenerator.new(table, options).generate
          end

          if options[:enabled_outputs].include?('typescript')
            Ratbug::Generators::TypescriptGenerator.new(table, options).generate
          end
        end
      end

      private

      # @param [String] table_names
      # @param [Proc] converter table_name to ApplicationRecord converting Proc
      # @return [ApplicationRecord|NilClass]
      def table_name_to_model(table_name, converter)
        converter[table_name]
      rescue => e
        p e
        puts "table_name: #{table_name}, cannot find the corresponding model."
        nil
      end

    end
  end
end

