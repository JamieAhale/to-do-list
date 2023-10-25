class TasksController < ApplicationController

  PRIORITY_ORDER = ["Low", "Medium", "High"]

  def index
    
    @tasks = Task.all

    if params[:category_id].present?
        @tasks = @tasks.where(category_id: params[:category_id])
    end
    
    if params[:priority].present?
        @tasks = @tasks.where(priority: params[:priority])
    end

    if params[:query].present?
      @tasks = @tasks.where("title ILIKE ?", "%#{params[:query]}%")
    end

    case params[:sort_by]
    when "date_asc"
      @tasks = @tasks.order(due_date: :asc)
    when "date_desc"
      @tasks = @tasks.order(due_date: :desc)
    when "priority_asc"
      @tasks = @tasks.order(Arel.sql("CASE WHEN priority = 'Low' THEN 1 WHEN priority = 'Medium' THEN 2 WHEN priority = 'High' THEN 3 END ASC"))
    when "priority_desc"
      @tasks = @tasks.order(Arel.sql("CASE WHEN priority = 'Low' THEN 1 WHEN priority = 'Medium' THEN 2 WHEN priority = 'High' THEN 3 END DESC"))
    else
      @tasks = @tasks.order(due_date: :asc)
    end

    completed_status = params[:completed_status] || "false"

    if completed_status == "true"
      @tasks = @tasks.where(completed: true)
    elsif completed_status == "false"
      @tasks = @tasks.where(completed: false)
    end
        
  end

  def new
      @task = Task.new
  end

  def create
      @task = Task.new(task_params)
      if @task.save
          redirect_to root_path, notice: 'Task successfully created'
      else
          render :new
      end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      puts "Task updated successfully!"
      redirect_to tasks_path, notice: 'Task updated successfully.'
    else
      puts "Task failed to update. Errors: #{@task.errors.full_messages.join(', ')}"
      render :edit
    end
  end



  def complete
    @task = Task.find(params[:id])
    @task.update(completed: true)
    
    redirect_to tasks_path(permitted_params)
  end

  def incomplete
    @task = Task.find(params[:id])
    @task.update(completed: false)
  
    redirect_to tasks_path(permitted_params)
  end
  
    

  before_action :set_task

  def destroy
    @task.destroy
    redirect_to root_path, notice: 'Task successfully deleted'
  end

  private

  def permitted_params
    params.permit(:category_id, :priority, :sort_by, :search, :completed_status, :query)
  end

  def set_task
    @task = Task.find_by_id(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :completed, :due_date, :category_id, :priority, :notes)
  end

  helper_method :permitted_params


end
