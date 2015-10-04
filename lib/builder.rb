class Builder
  def initialize(template, controller)
    @template = ERB.new(template, nil, "-")
    @controller = controller
  end

  def build(page)
    context = Context.new(page, @controller)
    @template.result(context.get_binding)
  end

  def flash
    @controller.flash
  end

  class Context
    def initialize(page, controller)
      @page = ERB.new(page.rstrip).result
      @controller = controller
    end

    def get_binding
      call_binding { @page }
    end

    def flash
      @controller.flash
    end

    def method_missing(name, *args, opt)
      debugger
      if @controller.instance_methods.include?(name)
        @controller.send(name, *args)
      else
        raise NameError
      end
    end

    private

    def call_binding
      binding
    end
  end
end

# template = <<EOF
# <html>
#   <head>
#     <title>builder sample</title>
#   </head>
#   <body>
#     <%= yield %>
#   </body>
# </html>
# EOF

# page = <<EOF
# <h1>page</h1>
# <p>I'm in the template.</p>
# EOF

# Builder.new(template).build(page)