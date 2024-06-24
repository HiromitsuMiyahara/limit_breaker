class CreateRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :records do |t|
      t.integer :user_id
      t.string :part
      t.string :place
      t.string :exercise
      t.integer :weight
      t.integer :rep
      t.integer :set
      t.datetime :start_time
      t.timestamps
    end
  end
end
