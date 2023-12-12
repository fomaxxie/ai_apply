class AddCompanyNameToLetters < ActiveRecord::Migration[7.0]
  def change
    add_column :letters, :company_name, :string
  end
end
