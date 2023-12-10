class CreateBios < ActiveRecord::Migration[7.0]
  def change
    create_table :bios do |t|
      t.text :details
      t.text :cv_content
      t.text :bio_output
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
