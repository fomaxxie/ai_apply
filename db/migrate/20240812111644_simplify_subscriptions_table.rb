class SimplifySubscriptionsTable < ActiveRecord::Migration[7.0]
  def change
    change_table :subscriptions do |t|
      t.remove :status, :plan, :start_date, :end_date, :stripe_subscription_id, :last_payment_date, :next_payment_date
      t.boolean :active, default: true
      t.datetime :payment_date
      t.string :transaction_id
    end
  end
end
