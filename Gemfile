source "https://rubygems.org"

gemspec

mail_gem_version = (ENV['MAIL_GEM_VERSION'] || "<= 2.5.2")
if mail_gem_version == "HEAD"
  gem "mail", :git => "git@github.com:mikel/mail.git"
else
  gem "mail", mail_gem_version
end

rails_version = ENV['MAIL_ISO_2022_JP_RAILS_VERSION']

if rails_version == "HEAD"
  gem "actionmailer", :git => "git://github.com/rails/rails.git"
elsif rails_version && rails_version.strip != ""
  gem "actionmailer", rails_version
end
