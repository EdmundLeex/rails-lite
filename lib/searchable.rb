# require 'delegate'

# require_relative 'db_connection'
# require_relative 'sql_object'

module Searchable
  def where(params, table_name)
  	where_sql = params.keys.map { |k| "#{k} = ?" }.join(' AND ')

    result = DBConnection.execute2(<<-SQL, *params.values)
    	SELECT
    		*
    	FROM
    		#{table_name}
    	WHERE
    		#{where_sql}
    SQL
    result
    # parse_all(result.drop(1))
  end
end

