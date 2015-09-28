require 'sqlite3'
require 'active_support/inflector'
Dir["./lib/association/*.rb"].each { |file| require file }
Dir["./lib/*.rb"].each { |file| require file }
# module ActiveRecordLite
# 	class Base

# 	end
# end