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

### Default Features

When you run the generators, you will get a handful of features by default.
Cambium now ships with users, pages, media, and settings. Of these four, users
is the only model that will be inserted directly in your app. Cambium handles
the others.

See below for configuration and for adding users, while the following sections
talk about how pages, media, and settings work.

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
      sortable: true
      display_method: email_address
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
  buttons:
    delete: Delete User
  new: &new
    title: New User
    fields:
      name:
        type: string
      email:
        type: string
        readonly: true
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
* `table:columns:[column]:sortable`: Makes the column heading a link that will
  sort the data based on that column. This means **the column must be a column
  in the database**.
* `table:columns:[column]:display_method`: Provides ability to use an alias
  method for displaying the content. For example, you may store a `state` as a
  integer but want to return a `status` string for the table. You'd use `state`
  as the column and `status` as the display method.
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
* `form:buttons:delete`: Label for the delete button. If you remove `delete`
  entirely, then no delete button will exist (though you'd have to manually
  remove the route from your routes file).
* `form:[new/edit]`: New is the defaut, and most of the time Edit will inherit
  from new (the `<<: *new` is what handles that). But you can optionally
  override new values for your edit form.
* `form:[new/edit]:title`: Title for the form page.
* `form:[new/edit]:fields:[field]`: Each form field gets its own unique key to
  set it apart from the others.
* `form:[new/edit]:fields:[field]:type`: The type of the HTML field to render,
  which uses [SimpleForm](https://github.com/plataformatec/simple_form). *You
  can use `heading` here to break up your fields.*
* `form:[new/edit]:fields:[field]:crop`: If set to `true`, it will display a
  "Crop Image" option _after_ a file has been uploaded. This only applies to
  `file` types.
* `form:[new/edit]:fields:[field]:readonly`: If set to `true`, it will add the
  `readonly` attribute to the input field. *Not supported for markdown fields*.

> Note: Aside from the usual form field types, Cambium uses [Mark It
> Zero!](https://github.com/seancdavis/mark_it_zero) to render markdown
> editors. You can pass `markdown` as the `type` option and it will give you a
> markdown editor.

#### A Note On Files

File fields use [Dragonfly](https://markevans.github.io/dragonfly/) for
uploading and processing. To add an upload field to the CMS, you need to have
three attributes: `_name`, `_uid`, `_gravity`.

So, for example, if you have a field called, `upload`, You'll add the following
to your database **as string fields**:

- `upload_name`
- `upload_uid`
- `upload_gravity`

In addition to the features Dragonfly offers, Cambium has a built-in image
cropper. The option for this will appear _after_ a file has been uploaded _if
you specify the crop option for that field_. If those conditions are present,
you'll see a "Crop Image" below the image.

### Overriding the Base Controller

I've rearranged Cambium's CMS controllers so there is a blank `BaseController`
from which it inherits. You can manually override this in your app by creating
a `Cambium::BaseController` and loading the appropriate files.

First, generate the controller.

```text
$ bundle exec rails g controller cambium/base
```

That controller can inherit from any other controller in your app. The only
thing you need to ensure is that it loads the `CambiumHelper` from the
`Cambium` namespace. So, the base file should look like this:

```ruby
class Cambium::BaseController < ApplicationController
  helper Cambium::CambiumHelper
end
```

You can change `ApplicationController` to any other controller in your
application.

Pages
----------

Cambium now ships with a flexible pages feature.

### How Pages Work

Cambium keeps the base functionality of the pages within the gem in the
`Cambium::Page` model. It provides a templating engine that enables you to add
custom templates and apply them to individual pages.

The way it works is that you apply a template to an individual page. When that
page is rendered, it will render the associated template file (minus the
frontmatter, explained below) **inside your application layout**.

### Working With Templates

To add a new template, just add a file to `app/views/pages`. The name of the
file is what will drive the name of the template in the CMS.

To make everything work properly, it is recommended you **keep the default form
fields in your `pages.yml` config for the CMS.**

Templates can have a set of custom fields that enable you to capture custom
data on a page. You can't query that data directly, but you can get to it once
you have a page. The configuration for each template uses YAML frontmatter,
similar to [how Middleman works](https://middlemanapp.com/basics/frontmatter/).

Let's use an example to demonstrate. Let's say I have a `Post` model in my app
and I want a listing of posts to be displayed on a News template. I would begin
by creating a file for the news template: `app/views/pages/news.html.erb`.

Then let's say we want to capture a `tagline` attribute on the page. You would
place the frontmatter at the top of your file, and it will look something like
this:

```text
---
title: News
fields:
  tagline:
    type: string
    label: Tagline
---
```

It's important in this case that you **don't put the frontmatter in a ruby
block** (`<% %>`). It needs to be in plain text on the page.

Once this information is there, you are able to add a page with the News
template in the CMS. Once you select the News template and save the page, the
form will show the custom `tagline` field as an option. Go ahead and populate
that field.

When you are creating the body of the template, it will all be based around the
`@page` object. Meanwhile, the values of your fields are available as attribute
on the `@page` object. So, if you wanted to display a listing of all the posts
on this template, your file might look something like this:

```html
---
title: News
fields:
  tagline:
    type: string
    label: Tagline
---

<h1><%= @page.title %></h1>
<h2><%= @page.tagline %></h2>

<ul>
  <% Post.all.each do |post| %>
    <li><%= link_to post.title, post %></li>
  <% end %>
</ul>
```

### Setting Your Home Page

The page form has a _Set as home page_ option on it. If you check this, that
page will be designated as the home page of your application. To make it work,
you'll have to amend your `root` call in `config/routes.rb` to load Cambium's
home page.

```ruby
root :to => 'cambium/pages#home'
```

If you don't have a page set as the home page, this will fail gracefully. If
you have two pages set as the home page, it's going to pick the first match. In
other words, setting a page as the home page doesn't unset all the other home
pages.

### Options

There are a few methods on the `Cambium::Page` class:

- `home`: The home page.
- `published`: Published pages.
- `unpublished`: Unpublished pages.

On an instance of a `Cambium::Page`, you can call the following methods:

- `template`: A `PageTemplate` instance (see below for those options).
- `body`: The body of the page (it's main block of content).
- `published?`: Is the page published?
- `publish!`: Publish the page.

There are also a few attributes on an instance of a `Cambium::Page`:

- `title`
- `slug`: Automatically generated from the title.
- `description`
- `position`
- `page_path`: The full path to the page, including ancestors.
- `title_path`: Combines all the titles of the ancestors, split by `:`.

The `Cambium::PageTemplate` class mainly focuses on the field values for a
particular page, which it makes available as dynamic methods. But on the class
itself, you have a few methods:

- `all`: The templates in your app.
- `names`: The names of all the templates in your app.
- `find`: Takes a `name` argument and will return that template if it exists.

### Adding Media

Cambium also ships with a media library by default. You can apply files from
the library to an individual page. But, unlike other Cambium admin controllers,
you won't use `file` as the field type. Instead it is a `media` field type
which is specifically designed to pull files from the media library.

So, let's say you wanted to add a `featured_image` field to your News template. Your frontmatter may then look something like this:

```text
---
title: News
fields:
  tagline:
    type: string
    label: Tagline
  featured_image:
    type: media
    label: Featured Image
---
```

Accessing the actual file will work a little differently, though. We are using
Dragonfly for handling uploads and processing, so you don't get the URL
directly. Instead you get the `Document` object, which provides some
flexibility on what you can do with it.

For example, if you just wanted the URL to the file itself, then you might add
this to your template:

```html
<%= @page.featured_image.upload.url %>
```

But what if you wanted it cropped on the fly? You could do something like this:

```html
<%= @page.featured_image.upload.thumb('300x300#').url %>
```

### Adding/Overriding Functionality

Cambium pages use the `Cambium::Page` model. If you want to add some additional
functionality or change some inherent functionality, you could create a page
model (`app/models/page.rb`) that inherits from `Cambium::Page`.

```ruby
class Page < Cambium::Page
  # your custom configuration
end
```

You'll then need to override the controller and access the `Page` model instead
of the `Cambium::Page` model. Place the following code in
`app/controllers/cambium/pages_controller.rb`.

```ruby
class Cambium::PagesController < ApplicationController
  def show
    slug = request.path.split('/').last
    @page = ::Page.find_by_slug(slug)
    render :inline => @page.template.content, :layout => 'application'
  end

  def home
    @page = ::Page.home
    if @page.nil?
      render 'home_missing'
    else
      render :inline => @page.template.content, :layout => 'application'
    end
  end
end
```

### Disabling Pages

You can't technically disable pages, but you can _hide_ its functionality. The
best thing to do is to remove its configuration file (`config/admin/pages.yml`)
and remove it from the sidebar config (`config/admin/sidebar.yml`).

Media Library
----------

Cambium now ships with a media library. This lets you upload all your files to
one main library. This feature especially will receive much more attention over
time. Currently, they are built to be easily connected to pages.

To work with pages, see the previous section.

Cambium uses Dragonfly for uploading and image processing. To access a document
directly, you will use the `Cambium::Document` model. Once you have a
individual object, you can get to the Dragonfly methods through the `upload`
attribute.

So, for example, you can get to the page of the file with
`document.upload.url`, where `document` is a `Cambium::Document` object.

### Options

Here are the other methods on a document instance:

- `image?`: Is the file an image?
- `pdf?`: Is the file a PDF?
- `has_thumb?`: Can we generate an image thumbnail for the file?
- `thumb_url`: The URL to the thumbnail image (if it can be created).
- `ext`: The file extension

Site Settings
----------

Cambium also ships with site settings, which focuses on enabling your users to
change setting through the UI.

You work with this like you would any other model, except it's more about
finding individual records instead of creating custom fields for an object.

In other words, all the configuration happens in your `config/admin/settings.yml` file. You can see there are some default ones:

```yaml
site_title:
  type: string
  label: Site Title
site_description:
  type: text
  label: Site Description
```

Any setting field you create you can access from the `Cambium::Setting` model.
So, for example, if you want the value of `site_title` from the above config,
you just query: `Cambium::Setting.site_title`.

Be warned, though, that if you need several settings on one page, you're better
off grabbing a collection of the settings and then grabbing from your results
as you need them. I'll leave that up to you!

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
