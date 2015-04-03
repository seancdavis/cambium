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
        path = "#{attrs.path.split('.').last}_path"
        if attrs.path.split('.').first == 'cambium'
          attrs.path = @view.cambium.send(path)
        else
          attrs.path = send(path)
        end
      end
      sidebar
    end

  end
end
