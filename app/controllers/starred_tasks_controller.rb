class StarredTasksController < ApplicationController
  before_action :authenticate_user!
#  GET /starred_tasks/
  def index
    @starred_tasks = Task.joins(:starred_tasks).order("start_date DESC");
  end

#  POST /starred_tasks/1
  def add
    @task = Task.find(params[:id]);
    @is_starred = StarredTask.where(["task_id == ?", params[:id]])

    if @task && @is_starred.size <= 0
      star_task = @task.starred_tasks.create()
      redirect_to starred_tasks_url(@starred_tasks), notice: "Task starred"
    else
      redirect_to starred_tasks_url(@starred_tasks), notice: "Task is already starred"
    end
  end

#  DELETE /starred_tasks/1
  def destroy
    task = StarredTask.find_by("task_id = #{params[:id]}")
    if task.destroy
      redirect_to starred_tasks_url(@starred_tasks), notice: "Task removed";
    else
      render :index, status: :unprocessable_entity
    end
  end

end
