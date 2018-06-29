class StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  # GET /students
  # GET /students.json
  def index
    if current_user.admin?
      if params[:user_id]
        @students = Student.search(params[:user_id])
      end
        @students = Student.search(params[:user_id] )
        respond_to do |format|
          format.html
          format.csv { send_data @students.to_csv }
          format.xls  #{ send_data @products.to_csv(col_sep: "\t") }
        end
    else
      @students = Student.search(params[:search]).where(user_id: current_user.id)
      render :user_index
    end
  end

  def print_selected
    params[:ids].each do |id|
      student = Student.find(id)
      student.destroy
    end unless params[:ids].blank?
    redirect_to students_url, :notice => 'Selected student are deleted successfully!'
  end

  # GET /students/1
  # GET /students/1.json
  def show
    @student = Student.find(params[:id])
    if current_user.admin?
      @student.update_attributes(status: 'complete')
      @student.save!
    end
    respond_to do |format|
      format.html
      format.json { head :no_content }
      format.pdf do
        pdf = StudentPdf.new(@student)
        send_data pdf.render,
                  filename: "student_#{@student.name}",
                  type: 'application/pdf',
                  disposition: 'inline'
      end
    end
  end

  # GET /students/new
  def new
    @student = current_user.students.build(status: 'imcomplete')
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students
  # POST /students.json
  def create
    @student = current_user.students.build(student_params)
    @student.status = 'imcomplete'
    respond_to do |format|
      if @student.save
        format.html { redirect_to students_url, notice: 'Student was successfully created.' }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to students_url, notice: 'Student was successfully updated.' }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url, notice: 'Student was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:code, :name, :course_id, :user_id)
    end
    #add sortable format
    def sort_column
      Student.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
