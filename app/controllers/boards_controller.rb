class BoardsController < ApplicationController
  before_action :set_resource, only: [:show, :update, :destroy]

  def index
    @collection = Board.all
    json_response @collection
  end

  def show
    json_response @resource
  end

  def create
    @resource = Board.create!(resource_params)
    json_response @resource, :created
  end

  def update
    @resource.update(resource_params)
    head :no_content
  end

  def destroy
    @resource.destroy
    head :no_content
  end

  private

  def resource_params
    params.require(:board).permit(:title, :description)
  end

  def set_resource
    @resource = Board.find(params[:id])
  end
end
