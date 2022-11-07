class StarredTasksController < ApplicationController
  before_action :authenticate_user!
#  GET /starred_tasks/
  def index
    @collab_data = current_user.tasks.joins("right join collaborators on collaborators.task_id = tasks.id inner join users on users.id = collaborators.user_id left join avatars on avatars.id = users.avatar_id").select("tasks.id as taskId, collaborators.*, users.email, avatars.avatar_url").where("collaborators.is_accepted = true")
    puts @collab_data.inspect
    @starred_tasks = Task.joins(:starred_tasks).where("starred_tasks.user_id = #{current_user.id}").order("start_date DESC");
  end

#  POST /starred_tasks/1
  def add
    task = Task.find(params[:id]);
    @is_starred = StarredTask.where({task_id: params[:id], user_id: current_user.id})

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
      redirect_to starred_tasks_url(@starred_tasks), notice: "Removed from starred";
    else
      redirect_to "/starred_task/", notice: "Task could not be removed"
    end
  end
end
