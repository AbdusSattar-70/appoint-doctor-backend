class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.decimal :age
      t.json :address
      t.string :role
      t.string :photo
      t.string :email
      t.string :encrypted_password
      t.string :reset_password_token
      t.string :jti
      t.string :qualification
      t.text :description
      t.decimal :experiences
      t.datetime :available_from
      t.datetime :available_to
      t.decimal :consultation_fee
      t.decimal :rating
      t.string :specialization

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :jti, unique: true
  end
end
