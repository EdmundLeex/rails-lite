require 'webrick'
require_relative './lib/active_record_lite_base'
require_relative 'cat'
require_relative 'cats_controller'

require 'byebug'

router = Router.new
router.draw do
  get Regexp.new("^/cats$"), CatsController, :index
  get Regexp.new("^/cat/(?<id>\\d+)$"), CatsController, :show
  get Regexp.new("^/cats/new$"), CatsController, :new
  post Regexp.new("^/cats$"), CatsController, :create
  # get Regexp.new("^/cats/(?<cat_id>\\d+)/statuses$"), StatusesController, :index
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
