class LettersController < ApplicationController
  before_action :set_profiles, only: [:new, :edit, :create, :update]

  def index
    @letters = Letter.all
  end

  def new
    @letter = Letter.new
    @formats = Letter::FORMATS
  end

  def create
    @letter = Letter.new(letter_params)
    @letter.letter_output = @letter.ai_letter_output
    if @letter.save
      redirect_to letter_path(@letter), notice: 'Letter was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @letter = Letter.find(params[:id])
  end

  def edit
    @letter = Letter.find(params[:id])
    @formats = Letter::FORMATS
  end

  def update
    @letter = Letter.find(params[:id])
    @letter.letter_output = @letter.ai_letter_output

    if @letter.update(letter_params)
      redirect_to @letter, notice: 'Letter was successfully updated.'
    else
      @formats = Letter::FORMATS
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @letter = Letter.find(params[:id])
    @letter.destroy
    redirect_to dashboard_path, notice: 'Letter was successfully deleted.'
  rescue ActiveRecord::RecordNotFound
    redirect_to dashboard_path, status: :see_other, alert: 'Letter not found.'
  end

  private

  def letter_params
    params.require(:letter).permit(:profile_id, :format, :job_description, :company_name, :letter_output)
  end

  def set_profiles
    @profiles = Profile.all
  end
end
