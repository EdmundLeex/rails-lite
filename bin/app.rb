require 'byebug'

require 'webrick'
require_relative '../lib/controller_base'
require_relative '../lib/router'
debugger
require_relative '../../active_record/lib/active_record_lite_base'

class Cat < SQLObject
	self.finalize!
end

class CatsController < ControllerBase
  def index
    # debugger
    flash["errors"] = "oh year!!!"
    # render_content($cats.to_s, "text/text")
    
    redirect_to '/show'
  end

  def go
    # session["count"] ||= 0
    # session["count"] += 1
    # debugger
    # flash.now["errors"] = "invalid!!!"
    render :counting_show
    # redirect_to "/"
  end
end

# router = Router.new
# router.draw do
#   get Regexp.new("^/cats$"), Cats2Controller, :index
#   get Regexp.new("^/cats/(?<cat_id>\\d+)/statuses$"), StatusesController, :index
# end

# server = WEBrick::HTTPServer.new(Port: 3000)
# server.mount_proc('/') do |req, res|
#   route = router.run(req, res)
# end

# server.mount_proc('/show') do |req, res|
#   Cats2Controller.new(req, res).go
# end

# trap('INT') { server.shutdown }
# server.start