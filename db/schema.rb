ActiveRecord::Schema[7.0].define(version: 2023_07_28_060429) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appointments", force: :cascade do |t|
    t.datetime "appointment_date"
    t.json "status"
    t.json "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "doctor_id", null: false
    t.bigint "patient_id", null: false
    t.index ["doctor_id"], name: "index_appointments_on_doctor_id"
    t.index ["patient_id"], name: "index_appointments_on_patient_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.decimal "age"
    t.json "address"
    t.string "role"
    t.string "photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "jti", null: false
    t.string "qualification"
    t.text "description"
    t.decimal "experiences"
    t.datetime "available_from"
    t.datetime "available_to"
    t.decimal "consultation_fee"
    t.decimal "rating"
    t.string "specialization"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "appointments", "users", column: "doctor_id"
  add_foreign_key "appointments", "users", column: "patient_id"
end
