class Appointment < ActiveRecord::Base
  belongs_to :doctor
  belongs_to :patient

  after_create :make_billing

  def make_billing
    Billing.create(appointment_id: self.id, paid?: false, cost: self.doctor.cost)
  end
end
