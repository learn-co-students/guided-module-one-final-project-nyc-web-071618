class Doctor < ActiveRecord::Base
  has_many :appointments
  has_many :patients, through: :appointments
  has_many :billings, through: :appointments

  def schedule
    self.appointments.map do |appts|
      appts.date_and_time
    end
  end

  def schedule_conflicts(date)
    if self.schedule.include?(Date.parse(date)) == true
      puts "Date Unavailable" 
    else
      puts "No Conflict"
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
end
