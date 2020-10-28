class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.text :user_name
      t.text :phone_number
      t.text :product_name
      t.integer :cost
    end
  end
end
