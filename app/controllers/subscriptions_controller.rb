class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_subscription, only: [:edit, :update, :destroy]

  def new
    @subscription = Subscription.new
    # Load subscription plans or other necessary data
  end

  def create
    @subscription = current_user.build_subscription(subscription_params)
    if @subscription.save
      # Process payment and set up subscription via a service like Stripe
      redirect_to root_path, notice: "Subscription created successfully."
    else
      render :new
    end
  end

  # def edit
  #   # Edit subscription details
  # end

  # def update
  #   if @subscription.update(subscription_params)
  #     # Update subscription details, possibly updating payment details
  #     redirect_to root_path, notice: "Subscription updated successfully."
  #   else
  #     render :edit
  #   end
  # end

  # def destroy
  #   # Cancel the subscription
  #   @subscription.cancel! # You'll define this method in your model
  #   redirect_to root_path, notice: "Subscription canceled successfully."
  # end

  private

  def set_subscription
    @subscription = current_user.subscription
  end

  def subscription_params
    params.require(:subscription).permit(:plan, :status, :start_date, :end_date, :stripe_subscription_id, :last_payment_date, :next_payment_date)
  end
end
