require 'byebug'

require 'json'
require 'webrick'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    cookies = req.cookies.find { |cook| cook.name == '_rails_lite_app_session' }
    # debugger
    if cookies.nil?
      @session = {}
    else
      # debugger
      cookie_session = JSON.parse(cookies.value)
      if cookie_session.nil?
        @session = {}
      else
        @session = cookie_session
      end
    end
    # debugger
  end

  def [](key)
    @session[key]
  end

  def []=(key, val)
    @session[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    # debugger
    res.cookies << WEBrick::Cookie.new('_rails_lite_app_session', @session.to_json)
  end
end

class Flash
  def initialize(req)
    cookies = req.cookies.find { |cook| cook.name == '_rails_lite_app_flash' }
    # debugger
    if cookies.nil?
      @flash = { "showed" => false }
    else
      cookie_flash = JSON.parse(cookies.value)
      # debugger
      if cookie_flash.nil?
        @flash = { "showed" => false }
      else
        # debugger
        @flash = cookie_flash
      end
    end
    # debugger
  end

  def [](key)
    @flash[key]
  end

  def []=(key, val)
    @flash[key] = val
  end

  def store_flash(res)
    # debugger
    if @flash["showed"]
      @flash = { "showed" => false }
    else
      @flash["showed"] = true
    end

    res.cookies << WEBrick::Cookie.new('_rails_lite_app_flash', @flash.to_json)
  end

  def now
    @flash
  end
end
