# Loads config/settings.yml into SETTINGS[]
config_file = File.join(Rails.root,'config','settings.yml')
if File.exists?(config_file)
  SETTINGS = YAML.load_file(config_file)[Rails.env]
end

# Loads config/settings_private.yml (sensitive settings) into PRIVATE[]
private_file = File.join(Rails.root,'config','settings_private.yml')
if File.exists?(private_file)
  PRIVATE = YAML.load_file(private_file)[Rails.env]
end
