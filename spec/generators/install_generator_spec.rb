require 'rails_helper'

describe 'Cambium::InstallGenerator' do

  it 'copies the Cambium configuration file to the initializers directory' do
    config_file = 'config/initializers/cambium.rb'
    remove_file(config_file)
    should_have_no_file(config_file)
    %x(bundle exec rails g cambium:install)
    should_have_file(config_file)
    remove_file(config_file)
  end

end
