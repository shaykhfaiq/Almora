class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :status
      t.integer :sub_total
      t.integer :total
      t.integer :shipping_fee
      t.string :payment_method
      t.string :payment_status
      t.text :shipping_address
      t.datetime :placed_at

      t.timestamps
    end
  end
end
