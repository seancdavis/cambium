module Cambium
  class AdminPresenter

    def initialize(action_view)
      @view = action_view
    end

    # Resolves the values from config/admin/sidebar.yml and
    # puts them in an array
    #
    def sidebar
      @sidebar ||= begin
        sidebar = []
        load_config('sidebar').each { |k, attrs| sidebar << attrs.to_ostruct }
        sidebar.each do |attrs|
          # resolve route
          path = "#{attrs.route.split('.').last}_path"
          if attrs.route.split('.').first == 'cambium'
            attrs.route = @view.cambium.send(path)
          else
            attrs.route = @view.main_app.send(path)
          end
          # figure out if it's active
          attrs.active = false
          if(
            (
              attrs.controllers &&
              attrs.controllers.include?(@view.controller_name)
            ) || @view.request.path == attrs.route
          )
            attrs.active = true
          end
        end
        sidebar
      end
    end

    # Resolves the logic from config/admin/tables.yml and
    # places them in a hash that can be retrieved via the
    # `table` method
    #
    def tables
      @tables ||= begin
        tables = {}
        load_config('tables').each { |k, attrs| tables[k] = attrs.to_ostruct }
        tables
      end
    end

    # Retrieve data for one table
    #
    def table(name)
      tables[name]
    end

    private

      def load_config(filename)
        file = File.join(Rails.root,'config','admin',"#{filename}.yml")
        YAML.load_file(file)
      end

  end
end
