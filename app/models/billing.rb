class Billing < ActiveRecord::Base
  has_many :appointments
  has_many :doctors, through: :appointments
  has_many :patients, through: :appointments
end
