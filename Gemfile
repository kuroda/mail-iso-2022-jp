source "https://rubygems.org"

if mail_gem_version = ENV['MAIL_GEM_VERSION']
  if mail_gem_version == "HEAD"
    gem "mail", :git => "git@github.com:mikel/mail.git"
  else
    gem "mail", "= #{mail_gem_version}"
  end
else
  gem "mail", "<= 2.8.1"
end

rails_version = ENV['MAIL_ISO_2022_JP_RAILS_VERSION']

group :development, :test do
  gem "rake"
  gem "bundler"
  gem "activesupport"
  gem "minitest"
  gem "test-unit"
  gem 'net-imap', '~> 0.2.2'
  gem 'net-pop', '~> 0.1.1'
  gem 'net-smtp', '~> 0.3.0'
  if rails_version == "edge"
    gem "actionmailer", :git => "git://github.com/rails/rails.git"
  elsif rails_version && rails_version.strip != ""
    gem "actionmailer", rails_version
  end
  gem "rdoc", ">= 3.12"
end
