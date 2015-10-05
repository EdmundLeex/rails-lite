# require_relative 'searchable'
# require_relative 'assoc_options'

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)

    define_method(name) do
      owner_class = options.model_class

      hash = {}
      hash[options.primary_key.to_sym] = self.send(options.foreign_key)

      owner_data = owner_class.where(hash)[0]
    end

    assoc_options[name] = options
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self, options)
    

    define_method(name) do
      belonging_class = options.model_class

      hash = {}
      
      hash[options.foreign_key] = self.send(options.primary_key)

      result = belonging_class.where(hash)
      # debugger
    end
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
    @assoc ||= {}
  end

  def has_one_through(name, through_name, source_name)
    through_table = if through_name == :human
      'humans'
    else
      through_name.to_s.pluralize
    end

    source_table = source_name.to_s.pluralize

    define_method(name) do
      belong_to_obj = self.class.assoc_options[through_name]
      through_id = belong_to_obj.foreign_key

      # debugger
      through_obj = self.send(through_name)

      sql_frag = <<-SQL
        SELECT
          #{source_table}.*
        FROM
          #{source_table}
        JOIN
          #{through_table}
          ON #{through_table}.#{source_name}_id = #{source_table}.id
        WHERE
          #{through_table}.id = ?
      SQL

      belonging_info = DBConnection.execute2(sql_frag, through_obj.id)[1]
      source_class = source_name.to_s.camelcase.constantize
      source_class.parse_all(belonging_info).first
    end 
  end
end
