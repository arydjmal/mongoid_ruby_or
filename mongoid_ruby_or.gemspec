Gem::Specification.new do |s|
  s.name        = 'mongoid_ruby_or'
  s.version     = '0.1.0'
  s.authors     = ['Ary Djmal']
  s.email       = ['arydjmal@gmail.com']
  s.summary     = 'This gem hijacks the $or operator, doing one query per $or clause, merging the results with plain ruby.'
  s.homepage    = 'http://github.com/arydjmal/mongoid_ruby_or'

  s.add_dependency 'mongoid', '~> 3.1.6'

  s.add_development_dependency 'rake'

  s.files = Dir["#{File.dirname(__FILE__)}/**/*"]
end
