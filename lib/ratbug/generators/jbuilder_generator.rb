require 'fileutils'

module Ratbug
  module Generators
    class JbuilderGenerator
      def initialize(table, options)
        @table = table
        @options = options
      end

      def generate
        singular = @table.name.singularize
        output = ""
        output << "json.#{singular} do\n"
        columns.values.sort_by(&:name).each do |column|
          output << column_row(column, singular)
        end
        output << "end"

        dirname = File.dirname(output_path)
        unless File.directory?(dirname)
          FileUtils.mkdir_p(dirname)
        end

        File.open(output_path, "w") do |f|
          f.puts(output)
        end
        puts "generated: #{output_path}"
      end

      private

      def columns
        if @options[:omit_timestamps]
          @table.columns.except(:created_at, :updated_at)
        else
          @table.columns
        end
      end

      def column_row(column, receiver_name)
        "  json.#{column.name} #{receiver_name}.#{column.name}#{column_value_modifier(column)}\n"
      end

      def column_value_modifier(column)
        if column.enum.present?
          return ''
        end

        operator = column.nullable ? '&' : ''

        case column.type
        when :date, :datetime, :time then
          return "#{operator}.iso8601"
        else
          return ''
        end
      end

      def output_path
        @options[:output_dir].join("_#{@table.name.singularize}.jbuilder")
      end
    end
  end
end
