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