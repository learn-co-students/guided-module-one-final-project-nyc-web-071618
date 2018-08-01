class Patient < ActiveRecord::Base
  # include DPmethods
  has_many :appointments
  has_many :doctors, through: :appointments
  has_many :billings, through: :appointments

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
      puts "#{docs.index(doc) + 1}. #{doc.name}"
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
    Appointment.create(condition: condition, doctor_id: doctor_id, patient_id: self.id, date_and_time: date)
  end

end


