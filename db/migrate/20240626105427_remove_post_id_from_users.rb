class RemovePostIdFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :post_id, :bigint
  end
end
