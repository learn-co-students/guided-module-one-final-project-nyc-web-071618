class Appointment < ActiveRecord::Base
  belongs_to :doctor
  belongs_to :patient
  has_one :rating
  
  def create_rating(rating)
    # binding.pry
    Rating.create(appointment_id: self.id, rating: rating)
  end
end
