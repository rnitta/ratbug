require 'ratbug/column'

module Ratbug
  module TableExt
    def index(*,**)
      # do nothing
    end

    Column::VALID_COLUMN_TYPES.each do |type|
      define_method(type, -> (column_name, **options) {
        comment = options['comment'] || options[:comment]
        nullable = !(options['null'] == false || options[:null] == false)
        columns[column_name.to_sym] = Column.new(type, column_name.to_s, nullable, comment)
      })
    end
  end


  class Table
    attr_accessor :name, :columns

    def initialize(name)
      @name = name
      @columns = {}
    end

    # @param [ApplicationRecord] model
    def load_enums(model)
      model.defined_enums.each do |column_name, v|
        if v.is_a?(Hash)
          enum_values = v
        elsif v.is_a?(Array)
          enum_values = v.map.with_index(0) { |r, i| [r, i] }.to_h
        else
          fail "#{model.name} enum #{column_name.pluralize} is not valid"
        end
        columns[column_name.to_sym]&.set_enums(enum_values)
      end
    end

    def load_relations
      # TODO
    end

    # @param [ApplicationRecord] model
    def load_presence_validators(model)
      model.validators.filter { |r| r.is_a?(ActiveRecord::Validations::PresenceValidator) }.each do |validator|
        validator.attributes.each do |column_name_sym|
          columns[column_name_sym]&.set_nullable(false)
        end
      end
    end

    private

    include TableExt

    def method_missing(symbol, *argv, **argh)
      puts "t.#{symbol.to_s} has no correspond implementation currenlty"
      p argv
      p argh
    end
  end
end
