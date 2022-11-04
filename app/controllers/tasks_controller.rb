class TasksController < ApplicationController
  # before_action :set_task, only: %i[ show edit update destroy mark_complete ]
  # before_action :get_user, only: %i[ new create index]
  before_action :collab_data, only: %i[index collab_requests get_tasks_by_date]
  before_action :authenticate_user!
  # GET /tasks or /tasks.json
  def index
    if (params[:search])
      @tasks = current_user.tasks.where(["title LIKE ?","%#{params[:search]}%"])
    else
      @tasks = current_user.tasks.where(start_date: (Time.now)..(Time.now.next_day)).order("start_date DESC");
    end
  end

  # collaborators
  # GET /tasks/collabrequests
  def collab_requests
    @collab_requests = Avatar.joins("inner join users on avatars.id = users.avatar_id inner join tasks on tasks.user_id = users.id inner join collaborators on collaborators.task_id = tasks.id").select("users.full_name, users.email, avatars.*,tasks.id as task_id, tasks.title, tasks.end_date").where("collaborators.user_id = #{current_user.id} and collaborators.is_accepted != true").order("created_at DESC")
    @tasks = current_user.tasks.where(start_date: (Time.now)..(Time.now.next_day)).order("start_date DESC");
    render :index, notice: "collab requests updated"
  end



  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
  end

  # POST /tasks or /tasks.json
  def create
    # puts params["collab"]["email"]
    user = User.find(current_user.id)
    @task = user.tasks.create(task_params)
      if @task.save
        # add collab
        params["collab"]["email"].each do |email|
          if current_user.email != email.downcase
            user = User.select("users.id").find_by(email: email.downcase)
            if user
              Collaborator.create({task_id: @task.id, user_id: user.id, is_accepted: false, is_completed: false})
            end
          end
        end
        redirect_to tasks_url(@tasks), notice: "Task was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    @task = Task.find(params[:id])
      if @task.update(task_params)
     redirect_to tasks_url(@tasks), notice: "Task was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    user = User.find(current_user.id)
    task = user.tasks.find(params[:id])
    if task
      task.destroy
      redirect_to "/tasks" , notice: "Task deleted"
    else
      redirect_to "/tasks" , notice: "Task could not be deleted"
    end

  end

  # PUT/PATCH /tasks/1
  def mark_complete
    @task = Task.find(params[:id])
    @task.is_completed = true;
    if @task.update({:is_completed => @task.is_completed})
      redirect_to tasks_url(@tasks), notice: "Task marked completed"
    else
      render :index, status: :unprocessable_entity
    end
  end


   # GET /tasks/date/2022-10-19
   def get_tasks_by_date
    user = User.find(current_user.id)
    if params[:date]
      next_day_date = Date.parse(Date.parse(params[:date]).strftime("%Y-%m-%d")).next;
      @tasks = user.tasks.where(start_date: (params[:date])..("#{next_day_date}")).order("start_date DESC");
      @date = params[:date]
      render :index
    else
      redirect_to tasks_url(@tasks), notice: "specify date"
    end
   end

  private
    # # Use callbacks to share common setup or constraints between actions.
    # def set_task
    #   @task = Task.find(params[:id])
    # end

    # def get_user
    #   @user = User.find(current_user.id)
    # end

    # send collab data
    def collab_data
      if current_user
        @collab_data = current_user.tasks.joins("right join collaborators on collaborators.task_id = tasks.id inner join users on users.id = collaborators.user_id").select("tasks.id as taskId, collaborators.*, users.email, users.avatar_id")
      end
      # @collab_data = current_user.tasks.joins("right join collaborators on collaborators.task_id = tasks.id").select("tasks.id as taskId, collaborators.*")
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:id, :title, :description, :start_date, :end_date, :is_completed, :search, :date, email: [])
    end
end
