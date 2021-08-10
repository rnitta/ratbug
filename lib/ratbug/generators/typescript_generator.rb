require 'fileutils'

module Ratbug
  module Generators
    class TypescriptGenerator
      def initialize(table, options)
        @table = table
        @options = options
      end

      def generate
        output = ""
        @table.columns.values.filter { |c| c.enum.present? }.each do |column|
          output << enum_output(column)
        end

        output << "type #{@table.name.singularize.camelize} = {\n"
        @table.columns.values.sort_by(&:name).each do |column|
          output << column_row(column)
        end
        output << "};"

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

      def column_row(column)
        ret = "  #{column.name.camelize(:lower)}#{column.nullable ? '?' : ''}:"
        if column.enum.present?
          ret << " #{enum_type_name(column)};\n"
        else
          ret << " #{column_type_to_ts_type(column.type)};\n"
        end
        ret
      end

      def enum_output(column)
        type_name = enum_type_name(column)
        output = ""
        if @options[:ts_enum_output] === 'union_type'
          output << "type #{type_name} = "
          output << column.enum.keys.map do |enum_key|
            "'#{enum_key}'"
          end.join(' | ')
          output << ';'
        else
          # force string enum
          output << "enum #{type_name} {\n"
          column.enum.keys.map do |enum_key|
            output << "#{enum_key.camelize} = '#{enum_key}',\n"
          end.join(' | ')
          output << "}"
        end
        output << "\n\n"
      end

      def enum_type_name(column)
        "#{@table.name}_#{column.name}".pluralize.camelize
      end

      def column_type_to_ts_type(column_type)
        {
          bigint: 'number',
          binary: 'number',
          boolean: 'boolean',
          date: 'string',
          datetime: 'string',
          decimal: 'number',
          float: 'string',
          integer: 'number',
          json: 'string',
          primary_key: 'number',
          string: 'string',
          text: 'string',
          time: 'string'
        }[column_type.to_sym]
      end

      def output_path
        @options[:output_dir].join("_#{@table.name.singularize}.ts")
      end
    end
  end
end
