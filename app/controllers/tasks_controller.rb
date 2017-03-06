class TasksController < ApplicationController
  before_action :set_parent_resource
  before_action :set_resource, only: [:show, :complete, :update, :destroy]

  def index
    @collection = @parent_resource.tasks

    if params[:type] && %w(completed incomplete).include?(params[:type])
      @collection = @collection.send params[:type]
    end

    json_response @collection
  end

  def show
    json_response @resource
  end

  def create
    @resource = @parent_resource.tasks.create!(resource_params)
    json_response @resource, :created
  end

  def complete
    @resource.complete!
    head :no_content
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
    params.require(:task).permit(:title, :description)
  end

  def set_resource
    @resource = @parent_resource.tasks.find_by!(id: params[:id]) if @parent_resource
  end

  def set_parent_resource
    @parent_resource = Board.find(params[:board_id])
  end
end
