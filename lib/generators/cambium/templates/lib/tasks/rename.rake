namespace :rename do

  desc 'Rename Rails App'
  task :app, [:new_name] do |t, args|
    filenames = [
      'Rakefile',
      'app/views/layouts/admin.html.erb',
      'app/views/layouts/application.html.erb',
      'app/views/layouts/devise.html.erb',
      'config/application.rb',
      'config/environment.rb',
      'config/routes.rb',
      'config/environments/development.rb',
      'config/environments/test.rb',
      'config/environments/production.rb',
      'config/initializers/secret_token.rb',
      'config/initializers/session_store.rb',
    ]
    filenames.each do |filename|
      text = File.read(filename)
      File.open(filename, "w") do |file| 
        file << text.gsub(/Roots/, args[:new_name])
      end
      puts "CHECKED FILE >> #{filename}"
    end
  end

end
