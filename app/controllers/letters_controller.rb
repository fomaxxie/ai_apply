class LettersController < ApplicationController
  def index
    @letters = Letter.all
  end

  def new
    @letter = Letter.new
    @profiles = Profile.all
    @formats = Letter::FORMATS
  end

  def create
    @letter = Letter.new(letter_params)
    if @letter.save
      redirect_to dashboard_path, notice: 'Letter was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @letter = Letter.find(params[:id])
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
    params.require(:letter).permit(:profile_id, :format, :job_description, :letter_output)
  end
end
