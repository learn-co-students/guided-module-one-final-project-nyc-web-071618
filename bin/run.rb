require_relative '../config/environment'

puts 'Are you a Doctor or a Patient?'

input = gets.chomp.to_s.downcase

if input.start_with?("d")
  Doctor.check_doctor
elsif input.start_with?('p') 
  Patient.check_patient
else
  puts "Why can't you spell anything right?"
end
