module Ratbug
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def copy_tasks
        template 'ratbug.rake', 'lib/tasks/ratbug.rake'
      end
    end
  end
end
