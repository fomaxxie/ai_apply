class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def dashboard
    @profiles = current_user.profiles
    @letters = current_user.letters
    @bios = current_user.bios
  end

  def subscription
    # You can add any logic you need here, such as checking the current subscription status
  end
end
