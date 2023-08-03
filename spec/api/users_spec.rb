# require 'swagger_helper'

# describe 'Users API' do
#   path '/users/' do
#     post 'Create a user' do
#       tags 'Users'
#       consumes 'application/json'
#       parameter name: :user, in: :body, schema: {
#         type: :object,
#         properties: {
#           name: { type: :string },
#           role: { type: :string },
#           age: { type: :decimal },
#           email: { type: :string },
#           address: {
#             type: :object,
#             properties: {
#               street: { type: :string },
#               city: { type: :string },
#               state: { type: :string },
#               zip_code: { type: :string }
#             }
#           },
#           photo: { type: :string },
#           password: { type: :string },
#           password_confirmation: { type: :string },
#           qualification: {type: :string},
#           description: {type: :text},
#           experiences: {type: :decimal},
#           available_from: {type: :datetime},
#           available_to: {type: :datetime},
#           consultation_fee: {type: :decimal},
#           rating: {type: :decimal},
#           specialization: {type: :string},
#         },

#         required: %w[name role age email address photo password password_confirmation] if role="regular"
#         required: %w[name role age email address photo password password_confirmation
#        qualification description experiences available_from available_to consultation_fee rating specialization] if role="doctor"

#       }

#       response '200', 'successful' do
#         let(:regular_user) do
#           {
#             name: 'John Doe',
#             role: 'regular',
#             age: 30,
#             email: 'john@example.com',
#             address: {
#               street: '123 Main St',
#               city: 'New York',
#               state: 'NY',
#               zip_code: '10001'
#             },
#             photo: 'profile.jpg',
#             password: 'secret_password',
#             password_confirmation: 'secret_password'
#           }
#         end

#         let(:doctor) do
#           {
#             name: 'Dr. Smith',
#             role: 'doctor',
#             age:


require 'swagger_helper'

describe 'Users API' do
  path '/users/' do
    post 'Create a user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          role: { type: :string },
          age: { type: :decimal },
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
          qualification: {type: :string},
          description: {type: :text},
          experiences: {type: :decimal},
          available_from: {type: :datetime},
          available_to: {type: :datetime},
          consultation_fee: {type: :decimal},
          rating: {type: :decimal},
          specialization: {type: :string},
        },
        required: %w[name role age email address photo password password_confirmation]
      }

      response '200', 'successful' do
        let(:regular_user) do
          {
            name: 'John Doe',
            role: 'regular',
            age: 30,
            email: 'john@example.com',
            address: {
              street: '123 Main St',
              city: 'New York',
              state: 'NY',
              zip_code: '10001'
            },
            photo: 'profile.jpg',
            password: 'secret_password',
            password_confirmation: 'secret_password'
          }
        end

        let(:doctor) do
          {
            name: 'Dr. Smith',
            role: 'doctor',
            age: 40,
            email: 'smith@example.com',
            address: {
              street: '456 Oak St',
              city: 'Los Angeles',
              state: 'CA',
              zip_code: '90001'
            },
            photo: 'doctor_profile.jpg',
            password: 'doctor_password',
            password_confirmation: 'doctor_password',
            qualification: 'MD',
            description: 'Experienced doctor',
            experiences: 10,
            available_from: '2023-08-10T09:00:00Z',
            available_to: '2023-08-10T17:00:00Z',
            consultation_fee: 100.0,
            rating: 4.5,
            specialization: 'Cardiology'
          }
        end

        let(:user) { regular_user }

        run_test!
      end

      response '422', 'unprocessable entity' do
        let(:user) { { name: 'Invalid User' } } # Invalid user data to test the unprocessable entity response
        run_test!
      end
    end
  end
end
