namespace :cambium do

  namespace :setup do

    include SetupHelper

    desc 'Add default Gemfile and install gems'
    task :gems do
      # puts args
      # when "sqlite"
      #   @database = "sqlite"
      # when "postges", "postgresql", "pg"
      #   @database = "pg"
      # else
      #   @database = "mysql2"
      # end
      @database = "mysql2"
      @rails_version = '4.1.0'
      template 'Gemfile'
      bundle
    end

  end

end
