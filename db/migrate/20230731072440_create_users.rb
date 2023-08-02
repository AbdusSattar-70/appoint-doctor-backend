class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.decimal :age
      t.json :address
      t.string :role
      t.string :photo
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
  end
end
