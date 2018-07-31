class Billing < ActiveRecord::Base
  belongs_to :appointments
  has_many :doctors, through: :appointments
  has_many :patients, through: :appointments
end
