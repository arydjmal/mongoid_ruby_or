# mongoid_ruby_or

This gem hijacks the $or operator, doing one query per $or clause, merging the results with plain ruby.

## Background

**WARNING:** understand what this code does before using (it's only ~20 LOC!)

MongoDB is not the smartest when using indexes for the $or operator.

This is my case:

```ruby
class Brand
  include Mongoid::Document

  field :name, type: String

  has_many :resources
end

class Resource
  include Mongoid::Document

  field :name,       type: String
  field :content_id, type: String

  index({ brand_id: 1, name: 1 })
  index({ brand_id: 1, content_id: 1 })

  belongs_to :brand
end

```

Given the above indexes, I do queries like:

```ruby
brand.resources                           # will use index
brand.resources.where(name: 'test')       # will use index
brand.resources.where(content_id: 'test') # will use index

```

The problem comes when using the $or operator:

```ruby
brand.resources.or({name: 'test'}, {content_id: 'test'}) # will do a full scan
```

Unfortunately, it will not use an index unless it starts with the field from the $or's. In order to have indexes that satisfies that query and the ones from above we will need something like:

```ruby
index({ brand_id: 1 })
index({ name: 1, brand_id: 1 })
index({ content_id: 1, brand_id: 1 })

```

So in this simplified case, we will need to add an extra index.

Sometimes is not worth it, maybe that query is not use very often to justify the necessity to maintain the index, or you are trying to cut back on indexes for that collection.

This gem will add a #ruby_or method to the Mongoid::Criteria class, and do a query for each $or clause and then merge in ruby.

## Installation

Add to your Gemfile:

```ruby
gem :mongoid_ruby_or
```

For mongoid v3.x use:


```ruby
gem :mongoid_ruby_or, '0.1.0'
```

## Usage

Using the same example from above:

```ruby
# problematic query, will be slow as it will do a full scan
brand.resources.or({name: /^test/}, {content_id: /^test/}).limit(10)
```

```ruby
# this will do two fast queries and patch them together
brand.resources.or({name: /^test/}, {content_id: /^test/}).limit(10).ruby_or
```

## Some observations

 * ~~**built for a system running ruby 1.9.3, rails 3.2, mongo 2.6.3, and mongoid 3.1.6**, may not be an issue in the future~~
 * **built for a system running ruby 2.0.0, rails 4.2.6, mongo 2.6.3, and mongoid 5.1.1**, may not be an issue in the future
 * tested for simple $or clauses
 * can't do count for obvious reasons
 * ruby_or will cut the criteria chain and get results as soon as invoked, so use at the end
