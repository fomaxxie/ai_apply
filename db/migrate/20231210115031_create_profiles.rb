class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.string :full_name
      t.string :desired_position
      t.integer :years_of_experience
      t.text :technical_skills
      t.text :soft_skills
      t.text :details
      t.string :email
      t.string :phone_number
      t.string :location
      t.string :website
      t.string :linkedin
      t.string :twitter
      t.string :instagram
      t.string :github
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
