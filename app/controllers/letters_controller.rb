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
    @letter.letter_output = @letter.ai_letter_output
    if @letter.save
      redirect_to dashboard_path, notice: 'Letter was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @letter = Letter.find(params[:id])
  end

  def update
    @letter = Letter.find(params[:id])
    if @letter.update(letter_params)
      @letter.update(letter_output: @letter.ai_letter_output)
      redirect_to @letter, notice: 'Letter was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @letter = Letter.find(params[:id])
    @letter.destroy
    redirect_to dashboard_path, notice: 'Letter was successfully deleted.'
  rescue ActiveRecord::RecordNotFound
    redirect_to dashboard_path, status: :see_other, alert: 'Letter not found.'
  end

  def regenerate
    @letter = Letter.find(params[:id])
    @letter.update(letter_output: @letter.ai_letter_output)
    redirect_to @letter, notice: 'Letter was successfully regenerated.'
  end

  private

  def letter_params
    params.require(:letter).permit(:profile_id, :format, :job_description, :company_name, :letter_output)
  end
end
