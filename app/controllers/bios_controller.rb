class BiosController < ApplicationController
  before_action :set_profiles, only: [:new, :edit, :create, :update]
  before_action :set_bio, only: [:show, :edit, :update, :destroy]

  def index
    @bios = Bio.all
  end

  def new
    @bio = Bio.new
  end

  def create
    @bio = Bio.new(bio_params)

    @bio.bio_output = @bio.ai_bio_output

    if params[:bio][:cv_content].present?
      @bio.cv_content = extract_text_from_pdf(params[:bio][:cv_content])
    end

    if @bio.save
      redirect_to bio_path(@bio), notice: 'Bio was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    @bio.bio_output = @bio.ai_bio_output

    if params[:bio][:cv_content].present?
      @bio.cv_content = extract_text_from_pdf(params[:bio][:cv_content])
    end

    if @bio.update(bio_params)
      redirect_to @bio, notice: 'Bio was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
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

  def set_bios
    @bio = Bio.find(params[:id])
  end

  def set_profiles
    @profiles = Profile.all
  end

  def extract_text_from_pdf(pdf_file)
    reader = PDF::Reader.new(pdf_file.path)
    text = reader.pages.map(&:text).join("\n")
    text
  end
end
