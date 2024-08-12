class CheckoutController < ApplicationController
  def create
    # Create a Stripe Checkout session
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'], # Specify payment methods (e.g., card)
      line_items: [{
        price: 'price_1PmyxXKhj2XRxXoGeXjCUvvL', # Replace with your Stripe price ID
        quantity: 1,
      }],
      mode: 'payment', # Set to 'payment' for a one-time payment
      success_url: checkout_success_url + '?session_id={CHECKOUT_SESSION_ID}', # Redirect to success URL after payment
      cancel_url: checkout_cancel_url, # Redirect to cancel URL if payment is canceled
    )

    # Redirect the user to Stripe's hosted checkout page
    redirect_to session.url, allow_other_host: true
  end

  def success
    # Retrieve the session from Stripe using the session_id returned on success
    session = Stripe::Checkout::Session.retrieve(params[:session_id])

    # Assuming current_user is the user who made the payment
    subscription = current_user.subscription

    if subscription
      subscription.activate!(session.payment_intent) # Activate subscription with the transaction ID
    else
      current_user.create_subscription(active: true, payment_date: Time.current, transaction_id: session.payment_intent)
    end

    # Redirect to the dashboard or another page after successful payment
    redirect_to dashboard_path, notice: "Thank you for your purchase! Your subscription has been activated."
  end

  def cancel
    # Handle the case where the user cancels the payment
    redirect_to subscription_page_path, alert: "Payment was canceled. Please try again."
  end
end
