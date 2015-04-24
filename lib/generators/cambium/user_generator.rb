require 'rake'
require 'rails/generators'

module Cambium
  class UserGenerator < Rails::Generators::Base

    desc "Create a new user for your app."

    source_root File.expand_path('../../templates', __FILE__)

    class_option(
      :admin,
      :type => :boolean,
      :default => false,
      :description => "Make the user an admin"
    )

    argument :email, :type => :string
    argument :password, :type => :string

    # Create a user with the provided credentials
    def create_user
      if options.admin == true
        User.create!(
          :email => email,
          :password => password,
          :password_confirmation => password,
          :is_admin => options.admin
        )
      else
        User.create!(
          :email => email,
          :password => password,
          :password_confirmation => password
        )
      end
    end

  end
end
