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

### Generating Admin Controllers

A big portion of Cambium's power lies in its ability to spin up feature-full
CMS controllers and views in a snap.

Before you generate an admin controller, you need to make sure you have a
working data model. It's best if the model already has the columns you know
you're going to need (it's easy to add or remove later, but quicker if you have
what you need at the beginning).

Then you can run the generator.

```text
$ bundle exec rails g cambium:controller [model]
```

**Be sure you are using the proper class name of the data model.**

For example, if I have a `Page` model, this would be the command:

```text
$ bundle exec rails g cambium:controller Page
```

> Note: I'm working on making Cambium more powerful all the time. At the
> moment, it works best with simple form-type data.

The generator does a few things:

* Uses the standard Rails generate to generate a template in the `admin`
  namespace (using the example, your file would be at
  `app/controllers/admin/pages_controller.rb`).
* Adds a namespaced route to your routes file (`config/routes.rb`).
* Adds the Cambium config file (at `config/admin/pages.yml` in this example).
* Adds a generic sidebar item for your controller at
  `config/admin/sidebar.yml`.

See below for information on the sidebar and controller settings.

### Sidebar Settings

The sidebar in Cambium is driven by your `config/admin/sidebar.yml` settings
file. It's pretty semantic and simple.

The default sidebar is:

```yaml
dashboard:
  label: Dashboard
  route: cambium.admin_dashboard
  icon: dashboard
users:
  label: Users
  route: cambium.admin_users
  icon: users
  controllers: ['users']
```

The important thing to remember is you have to define a unique key for each
item. For example, if you accidentally named `users` as `dashboard`, then only
the last `dashboard` item gets rendered.

The options are:

* `label`: Text within the sidebar link
* `route`: Route to apply to the link (for custom settings, replace `cambium`
  with `main_app`)
* `icon`: The name of the icon to use, pulled from [IcoMoon's free
  set](https://icomoon.io/#preview-free)
* `controllers`: An array of controllers which, if the current page is using
  one of the controllers, the sidebar item will be highlighted (with an
  `active` class)

### Controller Settings

The controller settings are what drive the behavior of Cambium. And it's why,
for simple models, you don't have to add any code to your controller and you
don't need any views.

Each controller's settings file is named for that controller, and can be found
in `config/admin`. For example, the users controller settings are at
`config/admin/users.yml`.

Here is the default set for the users controller:

```yaml
model: User
table:
  title: Site Users
  scope: all
  columns:
    email:
      heading: Email
  buttons:
    new: New User
export:
  button: Export Users
  columns:
    name:
      label: Name
    email:
      label: Email
form:
  new: &new
    title: New User
    fields:
      name:
        type: string
      email:
        type: string
      password:
        type: password
      password_confirmation:
        type: password
  edit:
    <<: *new
    title: Edit User
```

Every setting plays a role. Let's step through each one.

* `model`: The name (with class case) of the model to be used for this
  controller
* `table:title`: The title to show on the controller's index view.
* `table:scope`: The scope method to run on the model. Most of the time this
  will be `all`, but maybe you need to order, limit, or filter your results.
  You need to do this through an [ActiveRecord
  Scope](http://guides.rubyonrails.org/active_record_querying.html)
* `table:columns:[column]`: Each column gets its own unique key, which
  distinguishes it from others
* `table:columns:[column]:heading`: The label for the column in the data table.
* `table:buttons:new`: Label for the "New" button. If you don't want a
  new button, remove this setting.
* `export`: This section handles an export option for your data table. Remove
  it if you don't want to offer that.
* `export:button`: The label for the export button.
* `export:columns:[column]`: Each column in the exported file gets its own
  unique key, which distinguishes it from others
* `export:columns:[column]:label`: The heading in the exported file for that
  column.
* `export:columns:[column]:output`: An optional method you can pass to each
  object to help with display.
* `form`: Settings for the form.
* `form:[new/edit]`: New is the defaut, and most of the time Edit will inherit
  from new (the `<<: *new` is what handles that). But you can optionally
  override new values for your edit form.
* `form:[new/edit]:title`: Title for the form page.
* `form:[new/edit]:fields:[field]`: Each form field gets its own unique key to
  set it apart from the others.
* `form:[new/edit]:fields:[field]:type`: The type of the HTML field to render,
  which uses [SimpleForm](https://github.com/plataformatec/simple_form).

> Note: Aside from the usual form field types, Cambium uses [Mark It
> Zero!](https://github.com/seancdavis/mark_it_zero) to render markdown
> editors. You can pass `markdown` as the `type` option and it will give you a
> markdown editor.

Model Options
----------

Cambium makes use of many gems, and uses the behavior of those gems to drive
much of its power. In many cases, this requires added options to your model.

### Searchable Models

To make items searchable (in the CMS and in the app), we use
[pg_search](https://github.com/Casecommons/pg_search). You need to include the
`PgSearch` module, and then call out the columns you want to search.

For example, if you have a `Page` model and you want `title` and `body` to be
searchable, you're model might look like this:

```ruby
class Page < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:title, :body]
end
```

### Activity Log

If you want to track the history of a model's records (which also means adding
it to the activity log in the CMS), you need to add `has_paper_trail` to your
model.

```ruby
class Page < ActiveRecord::Base
  has_paper_trail
end
```

The activity log in particular makes use of the `to_s` method for the model. In
this way, we make no assumptions about the default attribute that describes a
model's record. Usually this is something like `title` or `name`. If it were
`title`, then your model (from above) is:

```ruby
class Page < ActiveRecord::Base
  has_paper_trail

  def to_s
    title
  end
end
```

### Markdown to HTML

As mentioned above, Cambium uses [Mark It
Zero!](https://github.com/seancdavis/mark_it_zero) to render markdown editors.
You, therefore, also have the option to store a markdown text attribute and
have it automatically converted to HTML using the `after_save` callback.

If, for our `Page` example, you have `body_markdown` and `body_html` fields,
you can add your `body_markdown` attribute to the form and then the following
to your model:

```ruby
class Page < ActiveRecord::Base
  converts_markdown :body_markdown, :body_html
end
```

See [this section](https://github.com/seancdavis/mark_it_zero#converting-to-
html) of the Mark It Zero! docs for more information and options.

Contributing
----------

1. Fork it ( https://github.com/[my-github-username]/cambium/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
