class ChangeDefaultActiveInSubscriptions < ActiveRecord::Migration[7.0]
  def change
    change_column_default :subscriptions, :active, from: true, to: false
  end
end
