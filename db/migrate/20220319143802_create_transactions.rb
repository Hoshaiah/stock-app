class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.string :stock
      t.integer :volume
      t.float :price
      t.string :method

      t.timestamps
    end
  end
end
