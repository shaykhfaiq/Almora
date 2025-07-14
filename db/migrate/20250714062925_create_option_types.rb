class CreateOptionTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :option_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
