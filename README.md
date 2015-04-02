Cambium
==========

Cambium serves three main purposes in Ruby on Rails applications:

1. Bootstrap Rails' standard installation by performing additional setup
   (things I find myself doing at the beginning of every project).
2. Facilitate development throughout the life of any project by abstracting
   repeatable bits of code.
3. Provide a simple, but flexible CMS for those applications that require it.

For now, the documentation will be continued in the README. This will be moved
out over time.

Setup
----------

Cambium lets you get up and running real fast. First, start you rails project
as you normally would.

```text
$ rails new my_app -d postgresql
```

> Note: Cambium only supports PostgreSQL. If you need to use another database,
> I suggest you add an option into Cambium and create a pull request. However,
> I strongly encourage you to give PostgreSQL a try.

Add Cambium to your Gemfile.

```ruby
gem 'cambium', '>= 1.0.0'
```

> I would probably commit at this time (so it's easy to rollback if you don't
> like something Cambium did).

Generate Cambium's (simple) configuration file.

```text
$ bundle exec rails g cambium:install
```

Edit the config (config/initializers/cambium.rb) to your liking.

Then, get your PostgreSQL database configured by editing `config/database.yml`
to your appropriate settings.

> **Make sure you do not commit between this step and finishing the setup
> process.** Cambium will ignore this database.yml file, which is good, as it
> may contain sensitive data.

Then, create your database:

```text
$ bundle exec rake db:create
```

Although optional, I suggest you at least start with the default `Gemfile`.

```text
$ bundle exec rails g cambium:gemfile
```

Remove the gems you don't want and then bundle.

```text
$ bundle install
```

And now you can run Cambium's auto-setup generator.

```text
$ bundle exec rails g cambium:app
```

Contributing
----------

1. Fork it ( https://github.com/[my-github-username]/cambium/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
