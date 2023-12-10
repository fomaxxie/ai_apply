class CreateLetters < ActiveRecord::Migration[7.0]
  def change
    create_table :letters do |t|
      t.string :format
      t.text :job_description
      t.text :letter_output
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
