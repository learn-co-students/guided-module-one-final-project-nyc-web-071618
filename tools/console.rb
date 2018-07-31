require_relative '../config/environment.rb'

def reload
  load 'config/environment.rb'
end
# Insert code here to run before hitting the binding.pry
# This is a convenient place to define variables and/or set up new object instances,
# so they will be available to test and play around with in your console

d1 = Doctor.create(name: "Dr Bob", specialization: "Dermatology", cost: 500.00)
d2 = Doctor.create(name: "Dr Joe", specialization: "ENT", cost: 250.00)
d3 = Doctor.create(name: "Dr Steve", specialization: "General Practitioner", cost: 53.00)
d4 = Doctor.create(name: "Dr Dave", specialization: "Dermatology", cost: 777.77)
d5 = Doctor.create(name: "Dr Donna", specialization: "General Practitioner", cost: 111.00)
d6 = Doctor.create(name: "Dr Ruth", specialization: "ENT", cost: 544.00)
d7 = Doctor.create(name: "Dr Liz", specialization: "Heart Surgeon", cost: 650.00)
d8 = Doctor.create(name: "Dr Yourboi", specialization: "Free Clinic", cost: 25.00)
d9 = Doctor.create(name: "Dr Bill", specialization: "Orthopedics", cost: 650.00)



binding.pry
0 #leave this here to ensure binding.pry isn't the last line
