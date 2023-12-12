class LettersController < ApplicationController
  before_action :set_profile, only [:create]

  def index
    @letters = Letter.all
  end

  def new
    @letter = Letter.new
    @profiles = Profile.all
  end

  def create
    @profile = Profile.find(params[:letter][:profile_id])
    @letter = @profile.letters.new(letter_params)
    if @letter.save
      redirect_to dashboard_path, notice: 'Letter was successfully created.'
    else
      @profiles = Profile.all # Make sure to pass the profiles back in case of re-render
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

  def set_profile
    @profile = Profile.find(params[:profile_id])
  end

  def letter_params
    params.require(:letter).permit(:profile_id, :format, :job_description, :letter_output)
  end
end
