class StarredTasksController < ApplicationController
  before_action :authenticate_user!
#  GET /starred_tasks/
  def index
    @starred_tasks = Task.joins("INNER JOIN starred_tasks ON tasks.id = starred_tasks.task_id where tasks.user_id = #{current_user.id}").order("start_date DESC");
  end

#  POST /starred_tasks/1
  def add
    task = Task.find(params[:id]);
    @is_starred = StarredTask.where(["task_id == ?", params[:id]])

    if task && @is_starred.size <= 0
      user = User.find(current_user.id);
      user.starred_tasks.create({task_id: task.id})
      redirect_to starred_tasks_url(@starred_tasks), notice: "Task starred"
    else
      redirect_to starred_tasks_url(@starred_tasks), notice: "Task is already starred"
    end
  end

#  DELETE /starred_tasks/1
  def destroy
    task = StarredTask.find_by({task_id: params[:id], user_id: current_user.id})
    if task.destroy
      redirect_to starred_tasks_url(@starred_tasks), notice: "Task removed";
    else
      redirect_to "/starred_task/", notice: "Task could not be removed"
    end
  end
end
