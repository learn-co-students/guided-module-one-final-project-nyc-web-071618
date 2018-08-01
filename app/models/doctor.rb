class Doctor < ActiveRecord::Base
  has_many :appointments
  has_many :patients, through: :appointments
  has_many :billings, through: :appointments
  
  def self.create_doctor(name, spec, cost)
    Doctor.create(name: name, specialization: spec, cost: cost)
  end

  def schedule
    self.appointments.map do |appts|
      appts.date_and_time
    end
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
  def doc_option_select
    puts "What are you here for?\n1. Your schedule\n2. Your rating\n3.Your income"
  end
  
  def self.check_doctor
    puts "What is your name?"
    
    name = gets.chomp.to_s.titleize
    doc_select = Doctor.all.find { |doctor| doctor.name.downcase == name.downcase }
    
    if doc_select == nil
      puts 'I see you are a new doctor, please follow the prompts to set up your profile.'
      puts 'What is your specialization?'
      spec = gets.chomp.to_s
      puts 'How much do you charge per visit?'
      cost = gets.strip.to_i
      puts "Creating your profile"
      create_doctor(name, spec, cost)
      doc_select = Doctor.all.find { |doctor| doctor.name.downcase == name.downcase }
    end

    doc_select.doc_option_select
  end
end
