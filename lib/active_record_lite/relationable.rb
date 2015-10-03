require_relative 'searchable'

module Relationable
  class Relation
    include Searchable

    def initialize(params, target_obj)
      # debugger
      table_name = target_obj.table_name
      result = where(params, table_name)
      @objs = target_obj.parse_all(result.drop(1))
    end

    def empty?
      objs.empty?
    end

    def first
      objs.first
    end

    def last
      objs.last
    end

    def all
      objs
    end

    def length
      objs.count
    end

    def [](id)
      objs[id]
    end

    alias_method :count, :length

    private
    attr_reader :objs
  end
end