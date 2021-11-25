class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :number
      t.integer :price
      t.timestamps
    end
  end
end
