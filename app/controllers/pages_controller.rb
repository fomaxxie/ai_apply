class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def dashboard
    @profiles = Profile.all
    @letters = Letter.all
    @bios = Bio.all
  end
end
