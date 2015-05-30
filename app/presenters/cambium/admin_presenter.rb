require 'csv'

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
      load_config(name).nil? ? nil : load_config(name).to_ostruct
    end

    # Resolve the routes for the given controller
    #
    def routes(object)
      begin
        n = @view.cambium
        @view.cambium.send("admin_#{@view.controller_name.pluralize}_path")
      rescue
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
        r[:delete] = r[:show]
      end
      r.to_ostruct
    end

    # Export a collection of objects to csv, based on the
    # configuration
    #
    def to_csv(collection)
      config = view(@view.controller_name).export
      output = CSV.generate do |csv|
        # Grab headings and methods
        headings = []
        methods = []
        config.columns.each_pair do |key, data|
          if data.label.nil?
            headings << key.to_s.titleize
          else
            headings << data.label
          end
          if data.output.nil?
            methods << key.to_s
          else
            methods << data.output
          end
        end
        csv << headings

        # Get the data
        collection.each do |obj|
          vals = []
          methods.each do |m|
            chain = m.split('.').reject(&:blank?)
            if chain.size > 1
              val = obj
              chain.each do |c|
                args = c[/\(.*?\)/]
                args = args.nil? ? [] : args[1..-2].split(',').map { |s| eval(s) }
                method = c.split('(').first
                val = args.size > 0 ? val.send(method, *args) : val.send(method)
              end
              vals << val
            else
              vals << obj.send(m)
            end
          end
          csv << vals
        end
      end
    end

    private

      def load_config(filename)
        file = File.join(Rails.root,'config','admin',"#{filename}.yml")
        File.exists?(file) ? YAML.load_file(file) : nil
      end

  end
end
