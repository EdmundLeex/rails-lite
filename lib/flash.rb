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
    @flash[key.to_sym] || @flash[key.to_s]
  end

  def []=(key, val)
    @flash[key.to_sym] = val
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

  def each(&proc)
    @flash.each do |type, message|
      next if type == 'showed'
      yield(type, message)
    end
  end
end