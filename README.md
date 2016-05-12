# Appsules

## Appsules? What the heck?!

Shouldn't your question be: 277 controllers and 440 models, where the heck do I begin?

### Good point. Let me rephrase: Appsules? What the heck?!

Appsules are a different way to organize your Rails app files.

Rails organizes them by architectural role: models directory, controllers directory, and so forth.
As the code base grows large it becomes hard to understand which code belongs together.

### So appsules are namespaces.

No.  It's just a directory structure.  There are no additional code constructs or abstractions.

### Ok, I think I get it.  Appsules are like when you organize 30 books by color but after you get 300 books you are forced to organize by subject in order to find a book without losing your mind.

Yes.

### And if you decide you are no longer interested in anthropology, you can just yank out the group of seven anthropology books instead of hunting through all 300.

Yes.

## How do I create a new appsule?

Let's say you want to create a new appsule called blog.  Move blog-related code from `app/` down
into `appsules/` like this, creating subdirectories as needed:

    appsules/
      blog/
        controllers/
          comments_controller.rb
          posts_controller.rb
        models/
          comment.rb
          post.rb
        views/
          comments/
            new.html.haml
            ...
          posts/
            index.html.haml
            new.html.haml
            ...

Leave blog code not found in `app/` (like migrations and routes) where it is.

Move all related tests and factories into `test/appsules` like so:

    test/
      appsules/
        blog/
          controllers/
            comments_controller_test.rb
            posts_controller_test.rb
          factories/
            comments.rb
            posts.rb
          models/
            comment_test.rb
            post_test.rb

## How do I appsulate all the things?

Don't go crazy; you don't need to end up with 100 tiny appsules.  One place to start is
to identify [bounded contexts](http://martinfowler.com/bliki/BoundedContext.html).

## When should I create a new appsule?

When a part of your app seems separate and cohesive (like an admin section, or a search page)
then extract it out into an appsule.  You can (and should!) build appsules from scratch; you
don't have to wait to extract it from existing `app/` code.

## Why wouldn't I use an engine?

Engines are another good way to break out code from a large `app/` directory.  Use an engine if:
1. You expect to share the code with another application (in which case also make it a local gem).
2. or you want to have more cleanly separated code (appsules do not enforce any code boundaries).

## How do I install appsules into my Rails app?

Add this to your Gemfile:

    gem 'appsules'

Then, in your `test_helper.rb` file, make sure your appsule factories get loaded:

    FactoryGirl.definition_file_paths = ['./factories']  # wherever you keep your factories
    Appsules.add_factory_girl_paths!                     # add factories defined in appsules
    FactoryGirl.find_definitions

All of the files you put into your appsule will be automagically loaded by Rails.  Also,
you'll get this cool rake task for free:

    `rake test:appsule:any_appsule_name`

## What else?

This doesn't work with RSpec yet; it assumes minitest.  It also assumes you are using FactoryGirl.

## Anything else?

Yes.  Leif Erikson was a Cantabrigian.  I have personally seen the historical marker that proves it.
