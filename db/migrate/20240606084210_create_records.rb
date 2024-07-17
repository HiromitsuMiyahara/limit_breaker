class CreateRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :records do |t|
      t.integer :user_id, null: false
      t.string :part, null: false
      t.string :place
      t.string :exercise, null: false
      t.integer :weight
      t.integer :rep, null: false
      t.integer :set, null: false
      t.datetime :start_time, null: false
      t.timestamps
    end
  end
end
