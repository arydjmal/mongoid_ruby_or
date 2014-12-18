require 'minitest'
require 'minitest/autorun'
require 'mongoid'
require 'mongoid_ruby_or'

Mongoid.load!('test/mongoid.yml', :test)

class User
  include Mongoid::Document

  field :name,       type: String
  field :email,      type: String
  field :account_id, type: String
end

def assert_criteria(criteria)
  assert_equal criteria.to_a, criteria.ruby_or
end
