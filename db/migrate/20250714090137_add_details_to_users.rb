class AddDetailsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :contact, :string
    add_column :users, :country, :string
    add_column :users, :city, :string
    add_column :users, :address, :text
  end
end
