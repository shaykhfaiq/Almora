class CreateVariantOptionValues < ActiveRecord::Migration[7.2]
  def change
    create_table :variant_option_values do |t|
      t.references :variant, null: false, foreign_key: true
      t.references :option_value, null: false, foreign_key: true

      t.timestamps
    end
  end
end
