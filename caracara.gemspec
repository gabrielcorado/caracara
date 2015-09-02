require './lib/caracara/version'

Gem::Specification.new do |s|
  s.name = 'caracara'
  s.version = Caracara.version
  s.summary = ''
  s.description = ''
  s.author = 'Gabriel Corado'
  s.email = 'gabrielcorado@mail.com'
  s.homepage = 'http://github.com/gabrielcorado/caracara'

  s.files = `git ls-files`.strip.split("\n")
  s.executables = Dir["bin/*"].map { |f| File.basename(f) }

  s.add_dependency 'rake'
  s.add_dependency 'mustache', '~> 1.0'

  s.add_development_dependency 'rspec', '~> 3.0.0'
  # s.add_dependency 'open4', '~> 1.3.4'
end
