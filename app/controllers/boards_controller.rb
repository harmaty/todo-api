class BoardsController < InheritedResources::Base

  def index
    @collection = Board.all
    render json: @collection
  end

  def show
    @resource = Board.where(:id => params[:id]).first
    render json: @resource
  end

  def create
    @resource = Board.create(resource_params)
    render json: @resource
  end

  def update
    @resource = Board.where(:id => params[:id]).first
    @resource.update(params[:board])
    render json: @resource
  end

  def destroy
    @resource = Board.where(:id => params[:id]).first
    @resource.destroy
    render json: @resource
  end

  private

  def resource_params
    params.require(:board).permit(:title, :description)
  end
end
