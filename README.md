# README

This README would normally document whatever steps are necessary to get the
application up and running.

* Dev Setup environment
I run the Windows 11 using WSL2 Unbuntu but most of these instruction should translate to other Dev environments

Use these instruction for the basic Windows setup:
https://gorails.com/setup/windows/11

You can skip the PostgreSQL setup, since we'll be using SQLite for both Dev and Produciton

* Mailcatcher
I also using Mailcatcher for local dev to test outgoing emails.

I found I need to first run:
    ``sudo apt install pkg-config``

Then run:
    ``gem install mailcatcher``

+ Tailwind install
https://tailwindcss.com/docs/installation/framework-guides/ruby-on-rails
``./bin/rails tailwindcss:install``




* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions
Currently using Fly.IO

- install Command line tools within WSL: [https://fly.io/docs/flyctl/install/]
  ``curl -L https://fly.io/install.sh | ``

