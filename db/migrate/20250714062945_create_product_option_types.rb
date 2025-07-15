class CreateProductOptionTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :product_option_types do |t|
      t.references :product, null: false, foreign_key: true
      t.references :option_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
