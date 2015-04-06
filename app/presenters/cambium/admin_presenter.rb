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

    # Gets all the data from the desired config file, which
    # are further broken up in other methods
    #
    def view(name)
      load_config(name).to_ostruct
    end

    # Resolve the routes for the given controller
    #
    def routes(object)
      if @view.cambium.respond_to?(
        "admin_#{@view.controller_name.pluralize}_path".to_sym
      )
        n = @view.cambium
      else
        n = @view.main_app
      end
      r = {
        :index => n.send("admin_#{@view.controller_name.pluralize}_path"),
        :new => n.send("new_admin_#{@view.controller_name.singularize}_path")
      }
      if !object.nil? && object.id.present?
        r[:edit] = n.send(
          "edit_admin_#{@view.controller_name.singularize}_path",
          object
        )
        r[:show] = n.send(
          "admin_#{@view.controller_name.singularize}_path",
          object
        )
      end
      r.to_ostruct
    end

    private

      def load_config(filename)
        file = File.join(Rails.root,'config','admin',"#{filename}.yml")
        YAML.load_file(file)
      end

  end
end