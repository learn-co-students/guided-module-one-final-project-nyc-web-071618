class Doctor < ActiveRecord::Base
  has_many :appointments
  has_many :patients, through: :appointments
  has_many :ratings, through: :appointments

  def getnumber(max)
    input = gets.chomp.gsub(/\D/,"").to_i
    if input.between?(1, max)
      return input
    else
      puts 'That is not a valid option'
      getnumber(max)
    end
  end

  def self.getnumber(max)
    input = gets.strip.gsub(/\D/,"").to_i
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

  def self.create_doctor(name, spec, cost)
    Doctor.create(name: name, specialization: spec, cost: cost)
  end

  def schedule
    self.appointments.map do |appts|
      appts.date_and_time
    end
  end

  def schedule_appointments
    self.appointments
  end

  def schedule_conflicts(date)
    if self.schedule.include?(date) == true
      nil
    else
      date
    end
  end

  def schedule_availability
    date_map = (Date.today..Date.today + 7).map do |date|
      date
    end
    available_days = date_map.select do |date|
      schedule_conflicts(date)
    end
    available_days.each do |day|
      puts "#{available_days.index(day) + 1}. #{day}"
    end
  end

  # date = Date.new(2018,8,5)
  # module DPmethods
  #   def check_schedule(date)
  #     if self.schedule.include?(date) == true
  #       return
  #     else
  #       Appointment.create()
  #     end
  #   end
  # end
  def option_reset
    40.times do print "-" end
    print "\n"
    self.doc_option_select
  end

  def income
    income_array = self.appointments.select do |appt|
      appt.paid? == true
    end
    payments = income_array.map do |appt|
      appt.doctor.cost
    end
    payments.sum
  end

  def doc_option_select
    puts "What are you here for?\n1. Your upcoming appointments\n2. Your past appointments\n3. Your income\n4. Your rating\n5. Back to start"
    input = getnumber(5)

    if input == 1
      count = self.appointments.select do |appt|
        if appt.date_and_time >= Date.today
          puts "#{appt.date_and_time} => Patient: #{appt.patient.name}, Condition: #{appt.condition}"
        end
      end
      if count.count == 0
        puts 'You have no upcoming appointments'
      end
      option_reset
    elsif input == 2
      count = self.appointments.select do |appt|
        if appt.date_and_time < Date.today
         puts "#{appt.date_and_time} => Patient: #{appt.patient.name}, Condition: #{appt.condition}"
        end
      end
      if count.count == 0
        puts 'You have no past appointments'
      end
      option_reset
    elsif input == 3
      # binding.pry
      if self.income == 0
        puts "You haven't made any money. Time to work harder!"
      else
        puts "You've netted: $#{self.income}"
      end
      option_reset
    elsif input == 4
      self.doc_rating_avg
      option_reset
    elsif input == 5
    end
  end

  def self.stripname(name)
    if name[0..5] == "doctor"
      name.slice!(0,6)
    elsif name[0..2] == "dr."
      name.slice!(0,3)
    elsif name[0..2] == "drd"
      name.slice!(0,2)
    elsif name[0..1] == "dr"
      name.slice!(0,2)
    end
    name
  end

  def self.check_doctor
    puts "What is your name?"

    name = getstring.downcase

    name = stripname(name)
    name = name.titleize

    doc_select = Doctor.all.find { |doctor| doctor.name.downcase == name.downcase }

    if doc_select == nil
      puts 'I see you are a new doctor, please follow the prompts to set up your profile.'
      puts 'What is your specialization?'
      spec = getstring.titleize
      puts 'How much do you charge per visit?'
      cost = getnumber(500000)
      puts "Creating your profile"
      create_doctor(name, spec, cost)
      doc_select = Doctor.all.find { |doctor| doctor.name.downcase == name.downcase }
    end

    doc_select.doc_option_select
  end

  def doc_rating_avg
    if self.ratings.length == 0
      puts "You don't have any ratings."
    else
      ratings_array = self.ratings.map do |rtgs|
      # binding.pry
        rtgs.rating.to_i
      end
      ratings_avg = ratings_array.inject{ |sum, el| sum + el }.to_f / ratings_array.size
      puts "Your rating average is #{ratings_avg}."
    end

  end
end
