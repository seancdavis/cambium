# Load config/settings.yml into Settings OpenStruct
#
begin
  config_file = File.join(Rails.root,'config','settings.yml')
  Settings = YAML.load_file(config_file)[Rails.env].to_ostruct
rescue
  raise "Can't find file: #{config_file}"
end

# Loads config/private.yml (sensitive settings) into Private
# OpenStruct
#
begin
  private_file = File.join(Rails.root,'config','private.yml')
  Private = YAML.load_file(private_file)[Rails.env].to_ostruct
rescue
  raise "Can't find file: #{private_file}"
end
