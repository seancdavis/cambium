module Cambium
  class AdminPresenter

    def sidebar
      sidebar = []
      file = File.join(Rails.root,'config','admin','sidebar.yml')
      YAML.load_file(file).each { |k, attrs| sidebar << attrs.to_ostruct }
      sidebar
    end

  end
end
