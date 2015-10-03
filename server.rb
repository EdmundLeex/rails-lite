require 'webrick'
require_relative './lib/rails_lite_base'
require_relative 'user'
require_relative 'task'
require_relative 'application_controller'
require_relative 'users_controller'
require_relative 'sessions_controller'
require_relative 'tasks_controller'

require 'byebug'
DBConnection.reset

router = Router.new
router.draw do
  get  Regexp.new("^/users$"), UsersController, :index
  get  Regexp.new("^/user/(?<id>\\d+)$"), UsersController, :show
  get  Regexp.new("^/signup$"), UsersController, :new
  post Regexp.new("^/signup$"), UsersController, :create

  get  Regexp.new("^/login"), SessionsController, :new
  post Regexp.new("^/login"), SessionsController, :create
  # get Regexp.new("^/users/(?<user_id>\\d+)/statuses$"), StatusesController, :index

  get Regexp.new("^/tasks"), TasksController, :show
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
