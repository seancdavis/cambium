require 'rails_helper'

describe Cambium::Configuration do

  it 'has a set of default values, available through "configuration"' do
    {
      :app_title            => 'Cambium',
      :development_url      => 'localhost:3000',
      :production_url       => 'example.com'
    }.each do |k,v|
      expect(Cambium.configuration.send(k)).to eq(v)
    end
  end

  it 'can be configured' do
    custom_config = {
      :app_title            => 'MyApp',
      :development_url      => 'local.dev',
      :production_url       => 'myapp.com'
    }
    Cambium.configure do |config|
      custom_config.each { |k,v| config.send("#{k}=", v) }
    end
    custom_config.each do |k,v|
      expect(Cambium.configuration.send(k)).to eq(v)
    end
  end

end
