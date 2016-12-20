require 'rails_helper'

describe 'Cambium::InstallGenerator' do

  let(:app_config) { 'config/application.rb' }
  let(:config_file) { 'config/initializers/cambium.rb' }

  before(:each) { remove_file(config_file) }
  after(:each) { remove_file(config_file) }

  it 'copies the Cambium configuration file to the initializers directory' do
    should_have_no_file(config_file)
    %x(bundle exec rails g cambium:install)
    should_have_file(config_file)
    # Double-checking that application config is the same.
    file_should_not_contain(app_config, 'g.fixture_replacement "factory_girl"')
  end

  it 'adds generator options if told to do so' do
    file_should_not_contain(app_config, 'g.fixture_replacement "factory_girl"')
    %x(bundle exec rails g cambium:install --thin-generators)
    file_should_contain(app_config, 'g.fixture_replacement "factory_girl"')
  end

end
