class Patient < ActiveRecord::Base
  # include DPmethods
  has_many :appointments
  has_many :doctors, through: :appointments
  has_many :billings, through: :appointments

  def choose_specialization(specialization)
    doctor
  end

  def make_appointment(condition, doctor_id, date)
    Appointment.create(condition: condition, doctor_id: doctor_id, patient_id: self.id, date_and_time: date)
  end

end
