class AddPostIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :post_id, :bigint
  end
end
