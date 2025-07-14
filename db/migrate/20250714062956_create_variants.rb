class CreateVariants < ActiveRecord::Migration[7.2]
  def change
    create_table :variants do |t|
      t.references :product, null: false, foreign_key: true
      t.string :sku
      t.decimal :price
      t.integer :stock_quantity

      t.timestamps
    end
  end
end
