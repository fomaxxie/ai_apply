class RemoveIsSubscribedFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :is_subscribed, :boolean
  end
end
