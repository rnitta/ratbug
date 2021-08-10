if Rails.env.development?
  namespace :ratbug do
    task execute: :environment do |_, args|
      require 'ratbug'
      table_names = args.extras
      Rails.application.eager_load! # table_name_to_model_converter
      options = Ratbug::GenerateConfig.new(
        enabled_outputs: ['jbuilder', 'typescript'],
        ts_prefer_type: true,
        ts_enum_output: 'union_type',
        ts_prefer_undefined: true,
        use_only_schema: false,
        output_dir: Rails.root.join('tmp', 'ratbug'),
        table_name_to_model_converter: -> table_name {
          ApplicationRecord.descendants.find { |klass| klass.table_name == table_name }
        }
      ).options
      table_names.each do |table_name|
        Ratbug::Runner.execute(table_name, options)
      end
    end
  end
end
