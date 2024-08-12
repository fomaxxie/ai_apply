class BiosController < ApplicationController
  before_action :set_profiles, only: [:new, :edit, :create, :update]
  before_action :set_bio, only: [:show, :edit, :update, :destroy]

  def index
    @bios = Bio.all
  end

  def new
    if current_user.can_create_letter?
      @bio = Bio.new
    else
      redirect_to new_subscription_path, alert: 'You have reached your limit of free letters. Please upgrade to Lifetime Access to continue generating letters.'
    end
  end

  def create
    @bio = Bio.new(bio_params)

    if current_user.can_create_bio?
      if params[:bio][:cv_content].present?
        @bio.cv_content = extract_text_from_pdf(params[:bio][:cv_content])
      end

      @bio.bio_output = @bio.ai_bio_output

      if @bio.save
        current_user.increment!(:bios_count)
        redirect_to bio_path(@bio), notice: 'Bio was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    else
      redirect_to new_subscription_path, alert: 'You have reached the limit of free bios. Please subscribe for unlimited access.'
    end
  end

  def destroy
    @bio.destroy
    redirect_to dashboard_path, notice: 'Bio was successfully deleted.'
  rescue ActiveRecord::RecordNotFound
    redirect_to dashboard_path, status: :see_other, alert: 'Bio not found.'
  end

  private

  def bio_params
    params.require(:bio).permit(:profile_id, :details, :cv_content, :bio_output)
  end

  def set_bio
    @bio = Bio.find(params[:id])
  end

  def set_profiles
    @profiles = current_user.profiles
  end

  def extract_text_from_pdf(pdf_file)
    reader = PDF::Reader.new(pdf_file.path)
    text = reader.pages.map(&:text).join("\n")
    text
  end
end
