class AddLettersCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :letters_count, :integer, default: 0
  end
end
