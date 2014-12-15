namespace :db do

  namespace :seed do

    desc "Create CSV Files for Models"
    task :create_files => :environment do
      Dir.glob("#{Rails.root}/app/models/*.rb").each { |file| require file }
      dir = "#{Rails.root}/db/csv"
      FileUtils.mkdir(dir) unless File.exists?(dir)
      ActiveRecord::Base.descendants.each do |model|
        unless File.exists?("#{dir}/#{model.to_s.tableize}.csv")
          File.open("#{dir}/#{model.to_s.tableize}.csv", 'w+') do |f| 
            f.write(model.columns.collect(&:name).join(','))
          end
          puts "CREATED FILE >> #{model.to_s.tableize}.csv"
        end
      end
    end

  end

end
