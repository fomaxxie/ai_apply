class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :status
      t.string :plan
      t.datetime :start_date
      t.datetime :end_date
      t.string :stripe_subscription_id
      t.datetime :last_payment_date
      t.datetime :next_payment_date

      t.timestamps
    end
  end
end
