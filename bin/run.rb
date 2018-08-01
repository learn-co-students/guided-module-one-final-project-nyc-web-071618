require_relative '../config/environment'

loop do
  puts 'Are you a Doctor or a Patient? If you want to exit type exit.'

  input = gets.chomp.to_s.downcase

  if input.start_with?("d")
    Doctor.check_doctor
  elsif input.start_with?('p') 
    Patient.check_patient
  elsif input.start_with?('e')
    break
  else
    puts "Why can't you spell anything remotely corrently right?"

  end
end
