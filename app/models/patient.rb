class Patient < ActiveRecord::Base
  # include DPmethods
  has_many :appointments
  has_many :doctors, through: :appointments
  
  def option_reset
    40.times do print "-" end
    print "\n"
    self.patient_option_select
  end
  def unpaid_appointments
    self.appointments.select do |appts|
      appts.paid? == false && appts.date_and_time <= Date.today
    end
  end
  
  def paybills
    puts 'Which bill would you like to pay for?'

    unpaid_appointments.each do |appts|
      puts "#{self.unpaid_appointments.index(appts) + 1 }. #{appts.date_and_time} => Doctor: Dr. #{appts.doctor.name}, Condition: #{appts.condition}, Owed: $#{appts.doctor.cost}"
    end

    input = gets.strip.to_i
    uappt = unpaid_appointments[input - 1]
    uappt.write_attribute(:paid?, true)
    uappt.save

    puts "Bill paid."
    option_reset
  end

  def choose_to_pay
    puts 'Would you like to pay now? (Y/N)'

    input = gets.chomp.to_s.upcase

    if input == 'YES' || input == 'Y'
      paybills
    elsif input == 'NO' || input == 'N'
      option_reset
    else 
      puts 'Invalid Option'
      choose_to_pay
    end
  end

  def leave_rating
    puts 'For which appointment would you like to leave a rating?'
    ratings = Rating.all.select do |rating|
      binding.pry
      rating.appointment.patient_id == self.id
    end
    unrated = self.appointments.select do |appts|
      appts.paid? == true && ratings.any? { |rating| rating.appointment == appts } == false
    end

    if unrated.count == 0
      puts "You have rated all your appointments."
      option_reset
    else
      unrated.each_with_index do |appts, index|
        puts "#{index + 1}. #{appts.date_and_time} => Doctor: Dr. #{appts.doctor.name}, Condition: #{appts.condition}"
      end
  
      input = gets.strip.to_i
  
      puts 'Leave a rating 1-10'
  
      intrate = gets.strip.to_i
      if (input) <= unrated.count
        unrated[input-1].create_rating(intrate)
      end
  
      puts 'Rating submitted'
  
      option_reset
    end
  end

  def choose_to_rate
    puts 'Would you like to leave a rating?'

    input = gets.chomp.to_s.upcase

    if input == 'YES' || input == 'Y'
      leave_rating
    elsif input == 'NO' || input == 'N'
      option_reset
    else 
      puts 'Invalid Option'
      choose_to_rate
    end
  end

  def speclist
    uniqspecs = Doctor.all.map do |doctor|
      doctor.specialization
    end.uniq
    uniqspecs.map do |spec|
      puts "#{uniqspecs.index(spec) + 1}. #{spec}"
    end
    select_spec(uniqspecs)
  end

  def select_spec(uniqspecs)
    input = gets.strip.to_i

    chosen_spec = uniqspecs[input - 1]

    docs = Doctor.all.select do |doctor|
      doctor.specialization == chosen_spec
    end
    select_doctor(docs)
  end

  def select_doctor(docs)
    docs.each do |doc|
      puts "#{docs.index(doc) + 1}: Dr. #{doc.name}"
    end

    input = gets.strip.to_i

    chosen_doctor = docs[input - 1]

    doc_inst = docs.find do |doc|
      doc == chosen_doctor
    end
    select_date(doc_inst)
  end

  def select_date(doc_inst)
    schedule_array = doc_inst.schedule_availability
    puts "Select the date you would like"

    input = gets.strip.to_i

    chosen_day = schedule_array[input - 1]

    puts "Why are you visiting?"

    condition = gets.chomp.to_s

    make_appointment(condition, doc_inst.id, chosen_day)
  end


  def make_appointment(condition, doctor_id, date)
    Appointment.create(condition: condition, doctor_id: doctor_id, patient_id: self.id, date_and_time: date, paid?: false)
  end

  def patient_option_select
    puts "Would you like to -\n1. Make an appointment\n2. See past appointments\n3. See future appointments\n4. See bills paid\n5. See bills pending\n6. Exit this menu"
    selection = gets.strip.to_i
    if selection == 1
      self.speclist
    option_reset
    elsif selection == 2
      self.appointments.select do |appts|
        if appts.date_and_time <= Date.today
          puts "#{appts.date_and_time} => Doctor: Dr. #{appts.doctor.name}, Condition: #{appts.condition}"
        end
      end
      option_reset
    elsif selection == 3
      self.appointments.select do |appts|
        if appts.date_and_time > Date.today
        puts "#{appts.date_and_time} => Doctor: Dr. #{appts.doctor.name}, Condition: #{appts.condition}"
        end
      end
      option_reset
    elsif selection == 4
      puts "Paid Bills"
      30.times do print "-" end
        print "\n"
      paid_stuff = self.appointments.select do |appts|
        if appts.paid? == true
          puts "#{appts.date_and_time} => Doctor: Dr. #{appts.doctor.name}, Condition: #{appts.condition}, Paid: $#{appts.doctor.cost}"
        end
      end
      if paid_stuff.count == 0
        puts "You have no bills paid."
        option_reset
      else
        choose_to_rate
      end
    elsif selection == 5
      puts "Unpaid Bills"
      30.times do print "-" end
        print "\n"
        unpaid_stuff = self.unpaid_appointments.select do |appts|
          puts "#{appts.date_and_time} => Doctor: Dr. #{appts.doctor.name}, Condition: #{appts.condition}, Owed: $#{appts.doctor.cost}"
        end
      if unpaid_stuff.count == 0
        puts "You have no bills to pay."
        option_reset
      else
        choose_to_pay
      end
    elsif selection == 6
      puts "You're out!"
      return
    else
      puts "Please select a valid option."
      self.patient_option_select
    end
  end

  def self.check_patient
    puts "Please provide your name, first and last."
    input = gets.chomp

    patient_find = Patient.all.find do |ps|
      ps.name.downcase == input.downcase
    end

    if patient_find == nil
      puts "You appear to be a new patient!"
      puts "How old are you?"
      age = gets.strip
      puts "What is your sex? (M, F, Other)"
      sex = gets.chomp
      Patient.create(name: input, age: age, sex: sex)
      patient_find = Patient.all.find do |ps|
        ps.name.downcase == input.downcase
      end
    else
      puts "Welcome back, #{input.titleize}!"
    end
    patient_find.patient_option_select
  end
end
