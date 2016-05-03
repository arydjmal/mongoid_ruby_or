module Mongoid
  class Criteria
    def ruby_or
      selector   = self.selector.dup
      or_clauses = selector.delete('$or')
      limit      = options[:limit]
      sort       = options[:sort]
      criteria   = klass.where(selector).limit(limit)
      results    = []

      or_clauses.each do |or_clause|
        results += criteria.where(or_clause).sort(sort).to_a
      end

      results.uniq!

      if sort
        field, direction = sort.first
        if direction == 1
          results.sort! { |x,y| x[field] <=> y[field] }
        else
          results.sort! { |x,y| y[field] <=> x[field] }
        end
      end

      limit ? results[0...limit] : results
    end
  end

  module Contextual
    class Mongo
      def ruby_or
        criteria.ruby_or
      end
    end
  end
end
