Gem::Specification.new do |s|
  s.name        = 'ruby-matrixim'
  s.version     = '0.0.0'
  s.date        = '2017-10-04'
  s.summary     = "Access the Matrix Instant Messagen API"
  s.description = "A simple hello world gem"
  s.authors     = ["Philipp Hirsch"]
  s.email       = 'itself@hanspolo.net'
  s.files       = ["lib/matrixim.rb", "lib/matrixim/connection.rb", "lib/matrixim/room.rb", "lib/matrixim/user.rb"]
  s.homepage    =
    'http://rubygems.org/gems/ruby-matrixim'
  s.license       = 'MIT'

  s.add_runtime_dependency 'rest-client', '~> 2.0', '>= 2.0.2'

  s.add_development_dependency 'rspec', '~> 3.6', '>= 3.6.0'
end