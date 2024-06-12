class CreateRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :records do |t|
      t.integer :user_id
      t.date :date, null: false
      t.string :part, null: false
      t.string :place, null: false
      t.string :exercise, null: false
      t.integer :weight
      t.integer :rep, null: false
      t.integer :set, null: false

      t.timestamps
    end
  end
end
