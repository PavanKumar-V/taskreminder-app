class CollaboratorsController < ApplicationController

  before_action :get_task, only: %i[mark_complete mark_uncomplete]

  # post /collab/new
  def add_collab
    collab = Collaborator.new
  end

  # GET /collab/email
  def get_emails
    puts params[:email_string]
    if params[:email_string]
      result = User.all.select("users.id, users.email").where("email Like '%#{params[:email_string]}%'");
      render :json => {:emails => result}.to_json
    end
  end

  # PATCH /collab/
  def accept_request
    # get task id
    collab_record = Collaborator.find_by({task_id: params[:task_id],user_id: current_user.id})

    if collab_record
      collab_record.update({is_accepted: true})
      redirect_to collab_request_url, alert: "Task Accepted"
    else
      redirect_to collab_request_url, alert: "Something went wrong"
    end
  end

  # delete /collab/
  def reject_request
    # get task id
    collab_record = Collaborator.find_by({task_id: params[:task_id],user_id: current_user.id})

    if collab_record
      collab_record.delete()
      redirect_to collab_request_url, alert: "Task rejected"
    else
      redirect_to collab_request_url, alert: "Something went wrong"
    end
  end

  # patch /collab/completed
  def mark_complete
    # params task_id
    if params[:task_id]
      collab = current_user.collaborators.where(task_id: params[:task_id], user_id: current_user.id).update({is_completed: true})
      redirect_to tasks_by_date_url(Date.parse(@task.start_date.strftime("%Y-%m-%d"))), notice: "task completed"
    else
      redirect_to "/tasks", notice: "something went wrong"
    end
  end

  # put /collab/completed
  def mark_uncomplete
    # params task_id
    if params[:task_id]
      collab = current_user.collaborators.where(task_id: params[:task_id], user_id: current_user.id).update({is_completed: false})
      redirect_to tasks_by_date_url(Date.parse(@task.start_date.strftime("%Y-%m-%d"))), notice: "Task marked incomplete"
    else
      redirect_to "/tasks", notice: "something went wrong"
    end
  end

  private

  def get_task
    @task = Task.find(params[:task_id])
  end

  def task_params
    params.permit( :email_string, :task_id)
  end
end
