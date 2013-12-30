
![Standout CMS Logo](http://standoutcms.se/assets/standout_cms-b5ce16797b6b31186f7b97355aefbb07.png)

## What is it?

This is a web application for creating and updating websites, including a complete shopping cart system.

## Installation: for production use (Ubuntu)

The CMS can be installed on multiple variants of *nix systems, including Mac OS X, but for production
use we normally choose the latest LTS version of Ubuntu.

```
# Ruby
apt-get install ruby

# Nginx
wget http://nginx.org/download/nginx-1.4.4.tar.gz
tar -xvzf nginx-1.4.4.tar.gz

# Passenger
gem install passenger
passenger-install-nginx-module

# MySQL
sudo apt-get install mysql-server

# The app
wget https://github.com/standout/Standout-CMS/archive/opensource.zip
tar -xvzf opensource.zip
cd opensource
gem install bundler rake
bundle install

# Configure the app
rake bootstrap

```

Now, edit config/application.yml and config/database.yml
TODO: finish the guide with setup of Nginx/passenger


## Installation: For development on Mac OS X

You need the following:

 * The code. `git clone git@github.com:standout/standoutcms.git`
 * [Homebrew](https://github.com/mxcl/homebrew/wiki/installation) (Not for the app itself, it's just more convenient for the other dependencies.)
 * Ruby (2.0.0-p353). To install with rbenv: `brew install rbenv` and `brew install ruby-build` and `rbenv rehash` and `rbenv install 2.0.0-p353`
 * Git `brew install git`
 * Imagemagick `brew install imagemagick`
 * MySQL. Homebrew or [MySQL.com](http://dev.mysql.com/downloads/mysql/)
 * bundler `gem install bundler`
 * Run `bundle install`
 * Pow `curl get.pow.cx | sh`. Now open http://standoutcms.dev/ in a browser to get instructions for symlinking.
 * MySQL-settings (see database.yml): `mysql> grant all on standoutcms.* to 'standoutdev'@'localhost' identified by 'dev404';`
 * Set up the database with `bundle exec rake db:setup`

Now you should be able to access http://standoutcms.dev/ and login with 'admin@example.com' and password 'abc123'.

## Configurating the app

First, run: `rake bootstrap`

The following files needs to be configured:

 * config/application.yml (TODO: move all/most settings here)
 * config/apache.conf (if you want to use Apache. Set your own domain name)
 * config/database.yml (TODO: fix database.local.yml)
 * config/deploy.rb (remote database settings)
 * config/environments/production.rb (smtp settings)

## Tests

The application has a test suite using Test::Unit. It should be working, so please run the test suite before making any commits.
During development you can use guard to make the tests run when you change your code. `bundle exec guard start`.
If you have Growl installed it will use that to display messages about the tests.

## API

Documentation on the API is in doc/api.md.

## Notes

 * This is a really old project that started with Rails 1 and has evolved based on customer request
   with help from many developers. The code can be inconsistent, strange or malfunctioning. If you want to
   help improve it you are more than welcome!

 * It looks like Webrick does not like underscores in the domain name (rightfully, since it is not part of the standard). So if you want
 to access a subdomain with underscores in dev mode you should use [Pow](http://pow.cx/) or Thin.

 * The app depends on using standoutcms.dev in development mode to get all links working.
