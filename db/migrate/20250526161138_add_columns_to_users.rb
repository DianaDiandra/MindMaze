class AddColumnsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :username, :string
    add_column :users, :age, :integer
    add_column :users, :image_url, :string
  end
end
