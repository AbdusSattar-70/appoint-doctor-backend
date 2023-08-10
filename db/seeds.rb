# # create 30 Doctors
# def generate_random_email
#   random_string = SecureRandom.hex(4)
#   "#{random_string}@example.com"
# end

# 30.times do |i|
#   name = "Dr. Doctor #{i + 1}"
#   email = generate_random_email
#   photo = "https://randomuser.me/api/portraits/women/#{i + 1}.jpg"

#   User.create!(
#     name: name,
#     age: 34,
#     email: email,
#     photo: photo,
#     role: 'doctor',
#     password: 'password345',
#     password_confirmation: 'password345',
#     qualification: 'MBBS',
#     description: 'Experienced physician specialized in gynecology.',
#     experiences: 10,
#     available_from: '2023-07-30 08:00 AM',
#     available_to: '2023-07-30 05:00 PM',
#     consultation_fee: 700,
#     rating: 4.6,
#     specialization: 'Gynecology',
#     address: {
#       street: '345 Cedar Street',
#       city: 'Miami',
#       state: 'FL',
#       zip_code: '33101'
#     }
#   )
# end
