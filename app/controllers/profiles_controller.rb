class ProfilesController < ApplicationController
  def index
    @profiles = Profile.all
  end

  def new
    @profile = Profile.new
  end

  def create
    @profile = Profile.new(profile_params)
    @profile.user = current_user
    if @profile.save
      redirect_to dashboard_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @profile = Profile.find(params[:id])
  end

  def edit
    @profile = Profile.find(params[:id])
  end

  def update
    @profile = Profile.find(params[:id])
    @profile.update(profile_params)
    @profile.save
    redirect_to dashboard_path
  end

  def destroy
    @profile = Profile.find(params[:id])
    @profile.destroy
    redirect_to dashboard_path, notice: 'Profile was successfully deleted.'
  rescue ActiveRecord::RecordNotFound
    redirect_to dashboard_path, status: :see_other, alert: 'Profile not found.'
  end

  private

  def profile_params
    params.require(:profile).permit(:full_name, :desired_position, :years_of_experience, :technical_skills, :soft_skills, :details,
                                    :phone_number, :location, :website, :linkedin, :twitter, :instagram, :github)
  end
end
