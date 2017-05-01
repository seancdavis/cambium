# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path("../dummy/config/environment.rb",  __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'

# Add additional requires below this line. Rails is not loaded until this point!

# Add additional requires below this line. Rails is not loaded until this point!
require 'capybara/rspec'
require 'capybara/rails'
require 'capybara-screenshot/rspec'
require 'capybara/poltergeist'
require 'database_cleaner'
require 'factory_girl'

Capybara.javascript_driver = :poltergeist

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|

  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  Capybara.default_max_wait_time = 10

  Capybara::Screenshot.register_filename_prefix_formatter(:rspec) do |example|
    "#{example.description.gsub(' ', '-').gsub(/^.*\/spec\//,'')}"
  end

  # Precompile assets before running suite.
  # config.before(:suite) do
  #   unless ARGV.any? {|e| e =~ /guard-rspec/ } || ENV['RSPEC_SKIP_ASSETS'].present?
  #     STDOUT.write "Precompiling assets..."
  #     require 'rake'
  #     Rails.application.load_tasks
  #     Rake::Task['assets:precompile'].invoke
  #     STDOUT.puts " done."
  #     Time.now.to_s
  #   end
  # end

  # config.after(:suite) do
  #   unless ARGV.any? {|e| e =~ /guard-rspec/ }
  #     FileUtils.rm_r(Rails.root.join('public','assets'))
  #   end
  # end

  config.before(:suite) do
    %w(png html).each do |x|
      Dir.glob("#{Rails.root}/tmp/capybara/*.#{x}").each { |f| FileUtils.rm(f) }
    end
    # Warden.test_mode!
    if config.use_transactional_fixtures?
      raise(<<-MSG)
        Delete line `config.use_transactional_fixtures = true` from rails_helper.rb
        (or set it to false) to prevent uncommitted transactions being used in
        JavaScript-dependent specs.
        During testing, the app-under-test that the browser driver connects to
        uses a different database connection to the database connection used by
        the spec. The app's database connection would not be able to access
        uncommitted transaction data setup over the spec's database connection.
      MSG
    end
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :feature) do
    # :rack_test driver's Rack app under test shares database connection
    # with the specs, so continue to use transaction strategy for speed.
    driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test

    if !driver_shares_db_connection_with_specs
      # Driver is probably for an external browser with an app
      # under test that does *not* share a database connection with the
      # specs, so use truncation strategy.
      DatabaseCleaner.strategy = :truncation
    end
  end

  config.before(:each) do
    DatabaseCleaner.start
    ActionMailer::Base.deliveries = []
    @fixture_path = "#{Rails.root}/spec/fixtures"
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
    Warden.test_reset!
  end

  config.after(:each, type: :feature) do
    wait_for_requests_complete # if example.metadata[:type] == :feature
  end

  # config.include Devise::Test::ControllerHelpers, :type => :controller
  config.include FactoryGirl::Syntax::Methods
  # config.include FeatureHelpers, :type => :feature
  # config.include ControllerHelpers, :type => :controller
  # config.include TestHelpers
end

def wait_for_requests_complete
  stop_client
  RackRequestBlocker.block_requests!
  wait_for('pending AJAX requests complete') do
    RackRequestBlocker.num_active_requests == 0
  end
ensure
  RackRequestBlocker.allow_requests!
end

# Navigate away from the current page which will prevent any new requests from being started
def stop_client
  page.execute_script %Q{
    window.location = "about:blank";
  }
end

# Waits until the passed block returns true
def wait_for(condition_name, max_wait_time: 30, polling_interval: 0.01)
  wait_until = Time.now + max_wait_time.seconds
  while true
    return if yield
    if Time.now > wait_until
      raise "Condition not met: #{condition_name}"
    else
      sleep(polling_interval)
    end
  end
end
