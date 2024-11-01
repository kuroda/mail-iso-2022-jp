#!/bin/bash
#
# rbenv version

set -e

source /usr/local/share/chruby/chruby.sh
RUBIES=(~/.rbenv/versions/* ~/.rubies/*)

function run_for_2_1_0 {
  chruby $RUBY_VERSION

    for version in 2.7.1 2.8.0 2.8.1; do
        echo "Running bundle exec ruby test/mail_test.rb against mail $version using $RUBY_VERSION..."
        rm -f Gemfile.lock
        MAIL_GEM_VERSION=$version bundle install
        MAIL_GEM_VERSION=$version bundle exec ruby -Itest test/mail_test.rb
    done

    gem list --local bundler | grep bundler || gem install bundler --no-ri --no-rdoc

    RAILS_VERSIONS=(6.1.7.8)

    for version in ${RAILS_VERSIONS[@]}; do
        for mail_gem_version in 2.7.1 2.8.0 2.8.1; do
            rm -f Gemfile.lock
            echo "Running bundle exec rspec spec against actionmailer $version using $RUBY_VERSION..."
            MAIL_GEM_VERSION=$mail_gem_version MAIL_ISO_2022_JP_RAILS_VERSION=$version bundle install
            MAIL_GEM_VERSION=$mail_gem_version MAIL_ISO_2022_JP_RAILS_VERSION=$version bundle exec rake test_all
        done
    done
}

export RUBY_VERSION=2.6.4
# rbenv global 2.6.4
run_for_2_1_0

export RUBY_VERSION=3.0.0
# rbenv global 3.0.0
run_for_2_1_0

export RUBY_VERSION=3.1.3
# rbenv global 3.1.3
run_for_2_1_0

export RUBY_VERSION=3.2.4
# rbenv global 3.2.4
run_for_2_1_0

echo 'Success!'
