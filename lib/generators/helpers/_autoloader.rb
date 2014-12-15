Dir.glob(File.expand_path('../../helpers/**/*.rb', __FILE__)).each do |file|
  unless file == __FILE__
    require file
    module_name = []
    File.read(file).each_line do |line|
      if line =~ /module\ /
        module_name << line.gsub(/module\ /, '').strip
      end
    end
    include module_name.join('::').constantize
  end
end
