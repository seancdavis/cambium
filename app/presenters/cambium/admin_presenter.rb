module Cambium
  class AdminPresenter

    def initialize(action_view)
      @view = action_view
    end

    def sidebar
      sidebar = []
      file = File.join(Rails.root,'config','admin','sidebar.yml')
      YAML.load_file(file).each { |k, attrs| sidebar << attrs.to_ostruct }
      sidebar.each do |attrs|
        # resolve path
        path = "#{attrs.path.split('.').last}_path"
        if attrs.path.split('.').first == 'cambium'
          attrs.path = @view.cambium.send(path)
        else
          attrs.path = send(path)
        end
        # figure out if it's active
        attrs.active = false
        if(
          (
            attrs.controllers &&
            attrs.controllers.include?(@view.controller_name)
          ) || @view.request.path == attrs.path
        )
          attrs.active = true
        end
      end
      sidebar
    end

  end
end
