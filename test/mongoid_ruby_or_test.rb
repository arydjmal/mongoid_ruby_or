require 'test_helper'

class MongoidRubyOrTest < Minitest::Test
  def setup
    Mongoid.purge!
    User.create!(name: 'ary',    email: 'arydjmal@gmail.com', account_id: '1')
    User.create!(name: 'aron',   email: 'xaron@gmail.com',    account_id: '1')
    User.create!(name: 'xariel', email: 'arielx@gmail.com',   account_id: '1')
    User.create!(name: 'djmal',  email: 'djmal@gmail.com',    account_id: '1')
  end

  def test_ruby_or
    assert_criteria User.or({name: /^ar/},  {email: /^ar/})
    assert_criteria User.or({name: /^ary/}, {email: /^ary/})
    assert_criteria User.or({name: /^xxx/}, {email: /^xxx/})
  end

  def test_limit
    assert_criteria User.or({name: /^ar/}, {email: /^ar/}).limit(2)
  end

  def test_sort
    assert_criteria User.or({name: /^ar/}, {email: /^ar/}).asc(:name)
  end

  def test_limit_and_sort
    assert_criteria User.or({name: /^ar/}, {email: /^ar/}).limit(2).asc(:name)
  end

  def test_scoped_selector
    assert_criteria User.where(account_id: '1').or({name: /^ar/}, {email: /^ar/}).limit(2).asc(:name)
  end

  def test_when_on_contextual
    assert_criteria User.or({name: /^ar/}, {email: /^ar/}).sort(name: 1)
  end
end
