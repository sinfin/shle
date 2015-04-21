#!/usr/bin/env sh

# Set up Rails app. Run this script immediately after cloning the codebase.
# https://github.com/thoughtbot/guides/tree/master/protocol

# Exit if any subcommand fails
set -e

# make sure Node.js is on path
npm -v


# Set up Ruby dependencies via Bundler
gem install bundler --conservative
bundle check || bundle install

# Set up configurable environment variables
if [ ! -f .env ]; then
  cp .sample.env .env
fi

# Set up database and add any development seed data
bundle exec rake db:create db:migrate db:setup db:seed

# Add binstubs to PATH via export PATH=".git/safe/../../bin:$PATH" in ~/.zshenv
mkdir -p .git/safe

# Pick a port for Foreman
if ! grep --quiet --no-messages --fixed-strings 'port' .foreman; then
  printf 'port: <%= config[:port_number] %>\n' >> .foreman
fi

if ! command -v foreman > /dev/null; then
  printf 'Foreman is not installed.\n'
  printf 'See https://github.com/ddollar/foreman for install instructions.\n'
fi

cd "vendor/assets/javascripts" && bower install
cd ../../..

# Only if this isn't CI
# if [ -z "$CI" ]; then
# fi
