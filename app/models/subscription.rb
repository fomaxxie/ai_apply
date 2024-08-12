class Subscription < ApplicationRecord
  belongs_to :user

  def activate!(transaction_id)
    update(active: true, payment_date: Time.current, transaction_id: transaction_id)
  end
end
