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

App Setup
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

When you're done, you can migrate (and annotate), and be on your way!

```text
$ bundle exec rake db:migrate
$ bundle exec annotate
```

Admin / CMS
----------

### Install CMS

If you want to also setup a CMS, it's as simple as running the generator.

```text
$ bundle exec rails g cambium:admin
```

Run the migrations Cambium created with the admin generator.

```text
$ bundle exec rake db:migrate
$ bundle exec annotate
```

Make sure Cambium's engine is mounted in your `config/routes.rb` file.

```ruby
mount Cambium::Engine => '/'
```

It's best to mount it at the root because Cambium automatically namespaces its
routes.

At this point, you should be able to go to `localhost:3000/admin` and be
redirected to the login page (if you are not signed in). Once you have an admin
user and sign in successfully, you will be redirected to the admin dashboard.

### Adding Users

We have a generator for creating a new user, which takes an `--admin` option if
you want the user to have admin access.

```text
$ bundle exec rails g cambium:user [username] [password] [--admin / --no-admin]
```

Contributing
----------

1. Fork it ( https://github.com/[my-github-username]/cambium/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
