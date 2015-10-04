class Builder
  def initialize(template, controller)
    @template = ERB.new(template, nil, "-")
    @controller = controller
  end

  def build(page)
    context = Context.new(page, @controller)
    @template.result(context.get_binding)
  end

  # def flash
  #   @controller.flash
  # end

  # def form_authenticity_token
  #   @controller.form_authenticity_token
  # end

  class Context
    def initialize(page, controller)
      @controller = controller
      @page = ERB.new(page.rstrip).result(binding)
    end

    def get_binding
      call_binding { @page }
    end

    def flash
      @controller.flash
    end

    def form_authenticity_token
      @controller.form_authenticity_token
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