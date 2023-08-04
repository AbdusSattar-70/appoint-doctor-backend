# user_schema.rb

module UserSchema
  def self.schema
    {
      type: :object,
      properties: {
        name: { type: :string },
        role: { type: :string },
        age: { type: :integer },
        email: { type: :string },
        address: {
          type: :object,
          properties: {
            street: { type: :string },
            city: { type: :string },
            state: { type: :string },
            zip_code: { type: :string }
          }
        },
        photo: { type: :string },
        password: { type: :string },
        password_confirmation: { type: :string },
        qualification: { type: :string },
        description: { type: :string },
        experiences: { type: :integer },
        available_from: { type: :string, format: 'date-time' },
        available_to: { type: :string, format: 'date-time' },
        consultation_fee: { type: :number },
        rating: { type: :number },
        specialization: { type: :string }
      },
      required: %w[name role age email address photo password password_confirmation]
    }
  end
end
