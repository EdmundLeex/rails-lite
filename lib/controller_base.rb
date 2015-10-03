require 'active_support'
require 'active_support/core_ext'
require 'erb'
# require_relative './session'
# require_relative './params'

class ControllerBase
  attr_reader :req, :res, :params, :form_authenticity_token

  # Setup the controller
  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @already_built_response = false
    @params = Params.new(req, route_params)
    @form_authenticity_token = SecureRandom.urlsafe_base64

    verify_auth_token
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "Double rendering/redirecting" if already_built_response?

    res.header["location"] = url
    res.status = 302
    @already_built_response = true

    store_token_in_cookies
    session.store_session(res)
    # debugger
    flash.store_flash(res)
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "Double rendering/redirecting" if already_built_response?

    res.body = content
    res.content_type = content_type
    @already_built_response = true

    session.store_session(res)
    # debugger
    store_token_in_cookies
    flash.store_flash(res)
  end

  def render(template_name)
    path = "views/" + self.class.name.sub("Controller", "").downcase + "/#{template_name.to_s}.html.erb"
    # debugger

    template = File.read(path)      
    @res.body = ERB.new(template).result(binding)
    render_content(@res.body, "text/html")
  end

  def store_token_in_cookies
    res.cookies << WEBrick::Cookie.new('_rails_lite_app_token', @form_authenticity_token)
  end

  def session
    @session ||= Session.new(req)
  end

  def flash
    # debugger
    @flash ||= Flash.new(req)
  end

  def verify_auth_token
    if req.request_method == "POST"
      token_in_cookies = req.cookies.find do |cook|
        cook.name == "_rails_lite_app_token"
      end.value

      unless @params["authenticity_token"] == token_in_cookies
        raise "CSRF Attack!!!!!!!!!!"
      end
    end
  end

  def invoke_action(name)
    send(name)
  end
end