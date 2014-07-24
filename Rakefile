require 'bundler/setup'
require 'bundler/gem_tasks'
require 'wwtd/tasks'
require 'rake'
require 'rake/testtask'
require 'rdoc/task'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test mail-iso-2022-jp library.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/mail_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the mail-iso-2022-jp library.'
RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'MailIso2022Jp'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
