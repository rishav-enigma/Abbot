class CreateOrder < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :number
      t.decimal :total
      t.timestamps
    end
  end
end
