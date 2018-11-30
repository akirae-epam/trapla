class PlanDetail < ApplicationRecord
  has_many :belongings, dependent: :destroy
  has_many :payments, dependent: :destroy
  belongs_to :plan
end
