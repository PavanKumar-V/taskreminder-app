class TasksController < ApplicationController
  # before_action :set_task, only: %i[ show edit update destroy mark_complete ]
  # before_action :get_user, only: %i[ new create index]
  before_action :authenticate_user!
  # GET /tasks or /tasks.json
  def index
    if (params[:search])
      @tasks = current_user.tasks.where(["title LIKE ?","%#{params[:search]}%"])
    else
      @tasks = current_user.tasks.where(start_date: (Time.now)..(Time.now.next_day)).order("start_date DESC");
      # @tasks = Task.all.where(start_date: (Time.now)..(Time.now.next_day)).order("start_date DESC");
    end
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
    user = User.find(current_user.id)
    @task = user.tasks.create(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_url(@tasks), notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    @task = Task.find(params[:id])
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to tasks_url(@tasks), notice: "Task was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # PUT/PATCH /tasks/1
  def mark_complete
    @task = Task.find(params[:id])
    @task.is_completed = true;
    if @task.update({:is_completed => @task.is_completed})
      redirect_to tasks_url(@tasks)
    else
      render :index, status: :unprocessable_entity
    end
  end


   # GET /tasks/date/2022-10-19
   def get_tasks_by_date
    @user = User.find(current_user.id)
    if params[:date]
      next_day_date = Date.parse(params[:date]).strftime("%Y-%m-%d").next;
      @tasks = current_user.tasks.where(start_date: (params[:date])..("#{next_day_date}"))
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

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:id, :title, :description, :start_date, :end_date, :is_completed, :search, :date)
    end
end
