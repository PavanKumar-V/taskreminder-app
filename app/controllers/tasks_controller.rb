class TasksController < ApplicationController
  before_action :set_task, only: %i[ edit update destroy mark_complete ]
  before_action :get_user, only: %i[ new create index]
  before_action :collab_data, only: %i[index collab_requests get_tasks_by_date]
  before_action :collab_tasks, only: %i[index collab_requests get_tasks_by_date]
  before_action :before_show, only: %i[show]
  before_action :authenticate_user!
  # GET /tasks or /tasks.json
  def index
    if (params[:search])
      @tasks = current_user.tasks.where(["title LIKE ?","%#{params[:search]}%"])
    else
      @tasks = current_user.tasks.where(start_date: Date.parse("#{Time.now}")..Date.parse("#{Time.now}").next).order("start_date DESC");
    end
  end

  # collaborators
  # GET /tasks/collabrequests
  def collab_requests
    @collab_requests = Task.joins(:user, :collaborators).joins("inner join avatars on avatars.id = users.avatar_id").select("collaborators.task_id, tasks.title, tasks.end_date, users.full_name, users.email, avatars.avatar_url").where("collaborators.user_id = #{current_user.id} and collaborators.is_accepted != true").order("collaborators.created_at DESC")
    @tasks = current_user.tasks.where(start_date: (Time.now)..(Time.now.next_day)).order("start_date DESC");
    render :index, notice: "collab requests updated"
  end



  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
    @collaborators = Collaborator.joins(:task, :user).select("collaborators.*, users.email").where(task_id: @task.id)
  end

  # POST /tasks or /tasks.json
  def create
    # puts params["collab"]["email"]
    @task = current_user.tasks.create(task_params)
    @collaborators = []
      if @task.save
        # add collab
        add_or_remove_collaborator(params["collab"]["emails"], @task.id, "ADD")
        redirect_to "/tasks", notice: "Task was successfully created"
      else
        render :new, status: :unprocessable_entity
      end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    @collaborators = Collaborator.joins(:task, :user).select("collaborators.*, users.email").where(task_id: @task.id)

    if @task.update(task_params)
      if params["collab"]["emails"]
        add_or_remove_collaborator(params["collab"]["emails"], @task.id, "ADD")
      end

      if params["collab"]["remove_emails"]
        add_or_remove_collaborator(params["collab"]["remove_emails"], @task.id, "REMOVE")
      end

      redirect_to tasks_url(@tasks), notice: "Task was successfully updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    task = current_user.tasks.find(params[:id])
    if task
      task.destroy
      redirect_to "/tasks" , notice: "Task deleted"
    else
      redirect_to "/tasks" , notice: "Task could not be deleted"
    end
  end

  # get/show task/1
  def show
    # @collaborators = Collaborator.find_by(task_id: params[:id], user_id: current_user.id)

    @task = Task.find(params[:id])
    @collaborators = @task.collaborators.joins(:user).joins("inner join avatars on avatars.id = users.avatar_id").select("collaborators.*, users.email, avatars.avatar_url")

    render :show
  end

  # PUT/PATCH /tasks/1
  def mark_complete
    if @task.update({:is_completed => true})
      redirect_to tasks_url(@tasks), notice: "Task marked completed"
    else
      render :index, status: :unprocessable_entity
    end
  end


   # GET /tasks/date/2022-10-19
   def get_tasks_by_date
    if params[:date]
      next_day_date = Date.parse(Date.parse(params[:date]).strftime("%Y-%m-%d")).next;
      @tasks = current_user.tasks.where(start_date: (params[:date])..("#{next_day_date}")).order("start_date DESC");
      @date = params[:date]
      render :index
    else
      redirect_to tasks_url(@tasks), notice: "specify date"
    end
   end


  #  add collab
  def add_or_remove_collaborator(emails, task, action)
    if emails.length() > 0
      emails.each do |email|
        if current_user.email != email.downcase
          user = User.select("users.id").find_by(email: email.downcase);
          if user && action == "ADD"
            is_in_collab = Collaborator.find_by({task_id: task, user_id: user.id})
            if is_in_collab == nil
              Collaborator.create({task_id: task, user_id: user.id, is_accepted: false, is_completed: false});
            end
          elsif user && action == "REMOVE"
            Collaborator.delete_by({task_id: task, user_id: user.id});
          end
        end
      end
    end
  end
  private
    # # Use callbacks to share common setup or constraints between actions.
    def set_task
      begin
        # do something dodgy
        @task = current_user.tasks.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        # handle not found error
        redirect_to "/tasks", alert: "Only Task creator has access"
      end
    end

    def get_user
      @user = User.find(current_user.id)
    end

    # send collab data
    def collab_data
      if current_user
        @collab_data = current_user.tasks.joins("right join collaborators on collaborators.task_id = tasks.id inner join users on users.id = collaborators.user_id left join avatars on avatars.id = users.avatar_id").select("tasks.id as taskId, collaborators.*, users.email, avatars.avatar_url").where("collaborators.is_accepted = true")
      end
    end

    # get accepted collab tasks
    def collab_tasks
      if params[:date]
        next_day_date = Date.parse(Date.parse(params[:date]).strftime("%Y-%m-%d")).next;
        @collab_tasks = Task.where(start_date: (params[:date])..("#{next_day_date}")).joins(:collaborators).select("tasks.*, collaborators.is_completed as collab_is_complete").where("collaborators.user_id = #{current_user.id} and collaborators.is_accepted = true").order("start_date DESC");
      else
        @collab_tasks = Task.where(start_date: Date.parse("#{Time.now}")..Date.parse("#{Time.now}").next).joins(:collaborators).select("tasks.*, collaborators.is_completed as collab_is_complete").where("collaborators.user_id = #{current_user.id} and collaborators.is_accepted = true").order("start_date DESC");
      end
    end

    # before_show
    def before_show
        collaborator = Collaborator.find_by(task_id: params[:id], user_id: current_user.id)
        task = current_user.tasks.where(id: params[:id], user_id: current_user.id)

        if  task.empty? && collaborator.nil?
          redirect_to "/tasks", alert: "Only Task creator has access"
        end
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:id, :title, :description, :start_date, :end_date, :is_completed, :search, :date, emails: [], existing_emails: [], remove_emails: [])
    end
end
