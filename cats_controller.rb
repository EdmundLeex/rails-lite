class CatsController < ControllerBase
  def index
    # debugger
    @cats = Cat.all

    flash.now["errors"] = "oh year!!!"

    render :index
    # render_content($cats.to_s, "text/text")
    
    # redirect_to '/show'
  end

  def show
    # debugger
    @cat = Cat.find(params[:id])

    @owner = @cat.human
    @house = @owner.house unless @owner.nil?
    
    render :show
  end

  def new
    @cat = Cat.new

    render :new
  end

  def create
    # debugger
    @cat = Cat.new(name: params[:cat][:name])

    if @cat.save
      redirect_to "/cat/#{@cat.id}"
    end
  end

end