require_relative 'searchable'

module Relationable
  class Relation
    include Searchable

    def initialize(params, target_class)
      # debugger
      @table_name = target_class.table_name
      @params = params
      @target_class = target_class
    end

    def force_query
      @result = where(params, table_name)
      target_class.parse_all(@result.drop(1))
    end

    def method_missing(name, *args, &proc)
      if Array.instance_methods.include?(name)
        @objs = force_query
        objs.send(name, *args, &proc)
      else
        raise NoMethodError
      end
    end

    def all
      objs || @objs = force_query
    end

    def new(params = {})
      params.merge!(@params)
      target_class.new(params)
    end

    def create(params = {})
      params.merge!(@params)
      target_class.create(params = {})
    end

    private
    attr_reader :objs, :table_name, :params, :target_class
  end
end