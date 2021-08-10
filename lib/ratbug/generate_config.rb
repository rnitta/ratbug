module Ratbug
  class GenerateConfig
    VALID_OPTION_KEYS = %i[
    enabled_outputs
  ts_prefer_type
  ts_enum_output_type
  ts_prefere_undefined
  use_only_schema
  output_dir
  table_name_to_model_converter
  ].freeze

    # timestamp
    # jbuilder indent usetab

    attr_accessor :override_options

    def initialize(**options)
      @override_options = {}
      options.each do |key, value|
        set(key, value)
      end
    end

    def set(key, value)
      key = key.to_sym
      puts "warning: GenerateConfig option #{key} has duplicated." unless @override_options[key].nil?
      @override_options[key] = value
      self
    end

    # @return [Hash<Symbol, Object>]
    def options
      {
        **default_options,
        **@override_options
      }
    end

    private

    # @return [Hash<Symbol, Object>]
    def default_options
      {
        enabled_outputs: ['jbuilder', 'typescript'],
        ts_prefer_type: true, # type or interface
        ts_enum_output: 'union_type', # 'enum'
        ts_prefere_undefined: true, # or null
        use_only_schema: false, # scan model files
        output_dir: Rails.root.join('tmp', 'ratbug'),
        table_name_to_model_converter: -> table_name { table_name.singularize.camelize.constantize }
      }
    end
  end
end
