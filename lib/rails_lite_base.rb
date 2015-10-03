require 'BCrypt'
require 'json'
require 'securerandom'
require 'webrick'
require 'sqlite3'
require 'active_support/inflector'
Dir["./lib/active_record_lite/association/*.rb"].each { |file| require file }
Dir["./lib/active_record_lite/*.rb"].each { |file| require file }
Dir["./lib/*.rb"].each { |file| require file }
# module ActiveRecordLite
# 	class Base

# 	end
# end