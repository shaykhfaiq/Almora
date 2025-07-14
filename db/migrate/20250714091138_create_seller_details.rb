class CreateSellerDetails < ActiveRecord::Migration[7.2]
  def change
    create_table :seller_details do |t|
      t.string :store_name
      t.string :store_url
      t.string :business_email
      t.string :ntn_number
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
