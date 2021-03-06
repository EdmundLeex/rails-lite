require 'webrick'
require_relative './lib/rails_lite_base'
require_relative './app/models/user'
require_relative './app/models/task'
require_relative './app/controllers/application_controller'
require_relative './app/controllers/users_controller'
require_relative './app/controllers/sessions_controller'
require_relative './app/controllers/tasks_controller'

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

  get  Regexp.new("^/tasks"), TasksController, :index
  post Regexp.new("^/tasks"), TasksController, :create
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
