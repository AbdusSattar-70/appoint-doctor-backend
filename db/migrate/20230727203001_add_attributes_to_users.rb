class AddAttributesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :qualification, :string
    add_column :users, :description, :text
    add_column :users, :experiences, :decimal
    add_column :users, :available_from, :datetime
    add_column :users, :available_to, :datetime
    add_column :users, :consultation_fee, :decimal
    add_column :users, :rating, :decimal
    add_column :users, :specialization, :string
  end
end
