version = File.read(File.expand_path("../VERSION",__FILE__)).strip

Gem::Specification.new do |s|
  s.name        = "mail-iso-2022-jp"
  s.version     = version
  s.authors     = ["Kohei MATSUSHITA", "Tsutomu KURODA"]
  s.email       = "hermes@oiax.jp"
  s.homepage    = "https://github.com/kuroda/mail-iso-2022-jp"
  s.description = "A set of patches for mikel's mail gem. With this, you can easily send and receive mails with ISO-2022-JP enconding (so-called 'JIS-CODE')."
  s.summary     = "A set of patches that provides 'mail' gem with iso-2022-jp conversion capability."
  s.license     = "MIT"

  s.required_ruby_version = ">= 1.9.3"

  s.add_dependency "mail", ">= 2.2.6", "<= 2.7.0"
  s.add_development_dependency "actionmailer", ">= 3.0.0", "< 6.0"
  s.add_development_dependency "rdoc", ">= 3.12", "< 5.0"

  s.files = %w(README.md Gemfile Rakefile) + Dir.glob("lib/**/*")
end
