module Ratbug
  class Column
    # enum: Hash<String, Integer>
    attr_accessor :type, :name, :nullable, :comment, :enum

    VALID_COLUMN_TYPES = %i[
      bigint
      binary
      boolean
      date
      datetime
      decimal
      float
      integer
      json
      primary_key
      string
      text
      time
    ].freeze

    # @param [Symbol] type
    # @param [String] name
    # @param [boolean] nullable
    # @param [String | null] comment
    def initialize(type, name, nullable, comment)
      fail "column type #{type} is invalid" unless VALID_COLUMN_TYPES.include?(type)
      fail "column name is required" if name.blank?

      @type = type
      @name = name
      @nullable = nullable
      @comment = comment
    end

    # @param [Hash<String, Integer>] enum_hash
    def set_enums(enum_hash)
      @enum = enum_hash
    end

    def set_nullable(nullable)
      @nullable = nullable
    end
  end
end
