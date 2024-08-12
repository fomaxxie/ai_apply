class LettersController < ApplicationController
  before_action :set_profiles, only: [:new, :edit, :create, :update]
  before_action :set_letter, only: [:show, :edit, :update, :destroy]

  def index
    @letters = Letter.all
  end

  def new
    if current_user.can_create_letter?
      @letter = Letter.new
      @formats = Letter::FORMATS
    else
      redirect_to new_subscription_path, alert: 'You have reached your limit of free letters. Please upgrade to Lifetime Access to continue generating letters.'
    end
  end

  def create
    @letter = Letter.new(letter_params)
    @formats = Letter::FORMATS

    if current_user.can_create_letter?
      @letter.letter_output = @letter.ai_letter_output
      if @profiles.exists?(@letter.profile_id) && @letter.save
        current_user.increment!(:letters_count)
        redirect_to letter_path(@letter), notice: 'Letter was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    else
      redirect_to new_subscription_path, alert: 'You have reached the limit of free letters. Please subscribe for unlimited access.'
    end
  end

  def show
  end

  def edit
    @formats = Letter::FORMATS
  end

  def update
    if current_user.can_create_letter? || @letter.profile.user_id == current_user.id
      if @letter.company_name != letter_params[:company_name] && !current_user.can_create_letter?
        redirect_to new_subscription_path, alert: 'You have reached the limit for free letters and cannot change the company name. Please subscribe for unlimited access.'
      else
        @letter.letter_output = @letter.ai_letter_output

        if @letter.update(letter_params)
          redirect_to @letter, notice: 'Letter was successfully updated.'
        else
          @formats = Letter::FORMATS
          render :edit, status: :unprocessable_entity
        end
      end
    else
      redirect_to new_subscription_path, alert: 'You have reached the limit of free letters and cannot update this letter. Please subscribe for unlimited access.'
    end
  end

  def destroy
    @letter.destroy
    redirect_to dashboard_path, notice: 'Letter was successfully deleted.'
  rescue ActiveRecord::RecordNotFound
    redirect_to dashboard_path, status: :see_other, alert: 'Letter not found.'
  end

  private

  def letter_params
    params.require(:letter).permit(:profile_id, :format, :job_description, :company_name, :letter_output)
  end

  def set_letter
    @letter = current_user.letters.find(params[:id])
  end

  def set_profiles
    @profiles = current_user.profiles
  end
end
