class DashboardController < ApplicationController
  def index
    json_response total_boards: Board.count,
                  total_tasks: Task.count,
                  total_incomplete_tasks: Task.incomplete.count
  end
end
