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

  def getnumber(max)
    input = gets.strip.to_i
    if input.between?(1, max)
      return input
    else
      puts 'That is not a valid option'
      getnumber(max)
    end
  end

  def getstring
    input = gets.chomp.to_s.gsub(/[^a-zA-Z]/, "")
    if input.class == String && !input.empty?
      return input 
    else
      puts "Not a string" 
      getstring
    end
  end
  def self.getstring
    input = gets.chomp.to_s.gsub(/[^a-zA-Z]/, "")
    if input.class == String && !input.empty?
      return input 
    else
      puts "Not a string" 
      getstring
    end
  end

  def paybills
    puts 'Which bill would you like to pay for?'

    unpaid_appointments.each do |appts|
      puts "#{self.unpaid_appointments.index(appts) + 1 }. #{appts.date_and_time} => Doctor: Dr. #{appts.doctor.name}, Condition: #{appts.condition}, Owed: $#{appts.doctor.cost}"
    end

      input = getnumber(unpaid_appointments.count)
      uappt = unpaid_appointments[input - 1]
      uappt.write_attribute(:paid?, true)
      uappt.save

    puts "Bill paid."
    option_reset
  end

  def choose_to_pay
    puts 'Would you like to pay now? (Y/N)'

    input = getstring.upcase

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
  
      input = getnumber(unrated.count)
  
      puts 'Leave a rating 1-10'
  
      intrate = getnumber(10)
      unrated[input-1].create_rating(intrate)
      
      puts 'Rating submitted'
  
      option_reset
    end
  end

  def choose_to_rate
    puts 'Would you like to leave a rating? (Y/N)'

    input = getstring.upcase

    if input == 'YES' || input == 'Y'
      leave_rating
    elsif input == 'NO' || input == 'N'
      option_reset
    else 
      puts 'Invalid Option'
      choose_to_rate
    end
  end

  def cancel_appointment
    puts 'Choose appointment to cancel.'
    i = 1
    self.appointments.each do |appts|
      if appts.date_and_time > Date.today
        appts
        puts "#{i}. #{appts.date_and_time} => Doctor: Dr. #{appts.doctor.name}, Condition: #{appts.condition}"
        i += 1
      end
    end
    future_appointments = self.appointments.select do |appts|
      appts.date_and_time > Date.today
    end
    cancel_appointment_continuted(future_appointments)
  end
  def cancel_appointment_continuted(future_appointments)
    input = getnumber(future_appointments.count)
      future_appointments[input - 1].delete
      puts 'Appointment cancelled'
      option_reset
  end
  
  def choose_to_cancel
    puts 'Would you like to cancel an appointment? (Y/N)'

        input = getstring.upcase

        if input == 'YES' || input == 'Y'
          cancel_appointment
        elsif input == 'NO' || input == 'N'
          option_reset
        else 
          puts 'Invalid Option'
          choose_to_cancel
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
    input = getnumber(uniqspecs.count)

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

    input = getnumber(docs.count)

    chosen_doctor = docs[input - 1]

    doc_inst = docs.find do |doc|
      doc == chosen_doctor
    end
    select_date(doc_inst)
  end

  def select_date(doc_inst)
    schedule_array = doc_inst.schedule_availability
    puts "Select the date you would like"

    input = getnumber(schedule_array.count)

    chosen_day = schedule_array[input - 1]

    puts 'Why are you visiting?'

    condition = getstring

    make_appointment(condition, doc_inst.id, chosen_day)
  end


  def make_appointment(condition, doctor_id, date)
    Appointment.create(condition: condition, doctor_id: doctor_id, patient_id: self.id, date_and_time: date, paid?: false)
  end

  def patient_option_select
    puts "Would you like to: \n1. Make an appointment\n2. See past visits\n3. See upcoming appointments\n4. See bills paid\n5. See bills pending\n6. Exit this menu"
    input = getnumber(6)
    if input == 1
      self.speclist
    option_reset
    elsif input == 2
      count = self.appointments.map do |appts|
        if appts.date_and_time <= Date.today
          puts "#{appts.date_and_time} => Doctor: Dr. #{appts.doctor.name}, Condition: #{appts.condition}"
        end
      end
      if count.count == 0
        puts "You have no past visits."
      end
      option_reset
    elsif input == 3
      count = self.appointments.map do |appts|
        if appts.date_and_time > Date.today
        puts "#{appts.date_and_time} => Doctor: Dr. #{appts.doctor.name}, Condition: #{appts.condition}"
        end
      end
      if count.count == 0
        puts "You have no upcoming appointments."
        option_reset
      else
        choose_to_cancel
      end
    elsif input == 4
      puts "Paid Bills"
      30.times do print "-" end
        print "\n"
      paid_stuff = self.appointments.map do |appts|
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
    elsif input == 5
      puts "Unpaid Bills"
      30.times do print "-" end
        print "\n"
        unpaid_stuff = self.unpaid_appointments.map do |appts|
          puts "#{appts.date_and_time} => Doctor: Dr. #{appts.doctor.name}, Condition: #{appts.condition}, Owed: $#{appts.doctor.cost}"
        end
        
      if unpaid_stuff.count == 0
        puts "You have no bills to pay."
        option_reset
      else
        choose_to_pay
      end
    elsif input == 6
      puts "You're out!"
      return
    else
      puts "Please select a valid option."
      self.patient_option_select
    end
  end

  def self.check_patient
    puts "Please provide your name, first and last."
    input = getstring

    patient_find = Patient.all.find do |ps|
      ps.name.downcase == input.downcase
    end

    if patient_find == nil
      puts "You appear to be a new patient!"
      puts "How old are you?"
      age = getnumber
      puts "What is your sex? (M, F, Other)"
      sex = getstring
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
