class LettersController < ApplicationController
  before_action :set_profiles, only: [:new, :edit, :create, :update]
  before_action :set_letter, only: [:show, :edit, :update, :destroy]

  def index
    @letters = current_user.letters
  end

  def new
    @letter = Letter.new
    @formats = Letter::FORMATS
  end

  def create
    @letter = current_user.letters.new(letter_params)
    @letter.user = current_user

    if current_user.can_create_letter?
      @letter.letter_output = @letter.ai_letter_output
      if @letter.save
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
    if current_user.can_create_letter? || @letter.user_id == current_user.id
      @letter.letter_output = @letter.ai_letter_output

      if @letter.update(letter_params)
        redirect_to @letter, notice: 'Letter was successfully updated.'
      else
        @formats = Letter::FORMATS
        render :edit, status: :unprocessable_entity
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
    @profiles = Profile.all
  end
end
