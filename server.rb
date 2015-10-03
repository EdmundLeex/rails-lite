require 'webrick'
require_relative './lib/rails_lite_base'
require_relative 'user'
require_relative 'users_controller'

require 'byebug'
DBConnection.reset

router = Router.new
router.draw do
  get Regexp.new("^/users$"), UsersController, :index
  get Regexp.new("^/user/(?<id>\\d+)$"), UsersController, :show
  get Regexp.new("^/users/new$"), UsersController, :new
  post Regexp.new("^/users$"), UsersController, :create
  # get Regexp.new("^/users/(?<user_id>\\d+)/statuses$"), StatusesController, :index
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

# server.mount_proc('/show') do |req, res|
#   CatsController.new(req, res).go
# end

trap('INT') { server.shutdown }
server.start
