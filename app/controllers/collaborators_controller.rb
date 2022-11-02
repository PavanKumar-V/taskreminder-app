class CollaboratorsController < ApplicationController
  # PATCH /collab/
  def accept_request
    # get task id
    puts params[:task_id]
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
    puts params[:task_id]
    collab_record = Collaborator.find_by({task_id: params[:task_id],user_id: current_user.id})

    if collab_record
      collab_record.delete()
      redirect_to collab_request_url, alert: "Task rejected"
    else
      redirect_to collab_request_url, alert: "Something went wrong"
    end
  end
end
