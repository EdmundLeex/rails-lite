# require_relative 'db_connection'
# require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.
require_relative './association/associatable'

class SQLObject
  extend Associatable
  include Relationable

  @prev_params = nil

  def self.where(params)
    if @prev_params == params
      @result
    else
      @result = Relation.new(params, self)
      @prev_params = params
    end

    @result.empty? ? [] : @result
    # debugger
  end
  
  def self.columns
    unless @cols
      table_info = DBConnection.execute2(<<-SQL)
        SELECT
          *
        FROM
          #{table_name}
      SQL

      @cols = table_info[0].map(&:to_sym)
    end

    @cols
  end

  def self.finalize!
    columns.each do |var|
      define_method("#{var}=") do |val|
        attributes[var.to_sym] = val
      end

      define_method("#{var}") { attributes[var.to_sym] }
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name || self.name.downcase + 's'
  end

  def self.all
    table_info = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL

    parse_all(table_info.drop(1))
  end

  def self.parse_all(*results)
    results.flatten.map { |result| self.new(result) }
  end

  def self.find(id)
    all[id - 1]
  end

  def self.find_by(hash)
    where_clause = hash.map do |k, v|
      "#{k} = '#{v}'"
    end.join(' and ')

    table_info = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{where_clause}
    SQL

    parse_all(table_info.drop(1))[0]
  end

  def self.first
    all[0]
  end

  def self.last
    all[-1]
  end

  def initialize(params = {})
    params.keys.each do |key|
      fail "unknown attribute '#{key}'" unless self.class.columns.include?(key.to_sym)
    end
    
    params.each { |k, val| send("#{k}=".to_sym, val) }
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    attributes.values
  end

  def save
    if attributes[:id].nil?
      insert
    else
      update_table
    end

    return true
  end

  # TODO: refactor update and update_table into one?
  def update(hash)
    set_str = hash.map { |field, val| "#{field} = '#{val}'" }.join(', ')
    sql_frag = <<-SQL
      UPDATE
        #{self.class.table_name}
      SET
        #{set_str}
      WHERE
        id = #{self.id}
    SQL
    DBConnection.execute2(sql_frag)
  end

  private

  def insert
    cols = self.class.columns.drop(1).map(&:to_s)

    sql_frag = <<-SQL
      INSERT INTO
        #{self.class.table_name} (#{cols.join(', ')})
      VALUES
        (#{cols.map { |col| col.prepend(':') }.join(', ')})
    SQL
    DBConnection.execute2(sql_frag, attribute_values)
    self.id = DBConnection.last_insert_row_id
  end

  def update_table
    cols = self.class.columns.drop(1).map(&:to_s)

    set_str = cols.map { |col| "#{col} = '#{attributes[col.to_sym]}'" }.join(', ')
    
    sql_frag = <<-SQL
      UPDATE
        #{self.class.table_name}
      SET
        #{set_str}
      WHERE
        id = #{self.id}
    SQL

    DBConnection.execute2(sql_frag)
  end
end
