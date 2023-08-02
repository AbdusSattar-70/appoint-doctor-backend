class CreateAppointments < ActiveRecord::Migration[7.0]
  def change
    create_table :appointments do |t|
      t.datetime :appointment_date
      t.json :status
      t.json :location
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
