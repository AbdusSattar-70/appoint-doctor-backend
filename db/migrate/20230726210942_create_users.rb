class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.decimal :age
      t.json :address
      t.string :role
      t.string :photo

      t.timestamps
    end
    add_index :users, :name, unique: true
  end
end
