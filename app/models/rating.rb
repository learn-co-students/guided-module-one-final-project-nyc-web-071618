class Rating < ActiveRecord::Base
  belongs_to :appointment
  has_one :doctor, through: :appointments
end
