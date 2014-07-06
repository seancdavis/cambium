require "cambium/version"

module Cambium
  require 'cambium/engine' if defined?(Rails)
  # if defined?(Rake)
    # puts Dir.pwd
    Dir["helpers/**/*.rb"].each do |f| 
      # puts f
      puts '123'
      # require f
    end
    Dir["tasks/**/*.rake"].each do |ext|
      puts '456'
      # load ext
    end
  # end
end
