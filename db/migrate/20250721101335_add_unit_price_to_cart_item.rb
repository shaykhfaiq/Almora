class AddUnitPriceToCartItem < ActiveRecord::Migration[7.2]
  def change
    add_column :cart_items, :unit_price, :decimal
  end
end
