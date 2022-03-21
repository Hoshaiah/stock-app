class CreateStocks < ActiveRecord::Migration[6.1]
  def change
    create_table :stocks do |t|
      t.string :name
      t.string :symbol
      t.float :average_price
      t.integer :volume

      t.timestamps
    end
  end
end
