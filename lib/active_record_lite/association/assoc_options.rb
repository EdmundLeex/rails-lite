# require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.camelcase.constantize
  end

  def table_name
    if class_name.downcase == 'human'
      'humans'
    else
      class_name.downcase.pluralize
    end
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    options.each do |opt, val|
      send("#{opt}=".to_sym, val)
    end

    @class_name ||= name.to_s.camelcase
    @foreign_key ||= "#{name}_id".to_sym
    @primary_key ||= :id
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    options.each do |opt, val|
      send("#{opt}=".to_sym, val)
    end

    @class_name ||= name.to_s.camelcase.singularize
    @foreign_key ||= "#{self_class_name.to_s.downcase}_id".to_sym
    @primary_key ||= :id
  end
end
