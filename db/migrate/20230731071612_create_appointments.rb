class CreateAppointments < ActiveRecord::Migration[7.0]
  def change
    create_table :appointments do |t|
      t.datetime :appointment_date
      t.json :status
      t.json :location

      t.timestamps
    end
  end
end
