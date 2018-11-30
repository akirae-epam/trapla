class PlanDetail < ApplicationRecord
  has_many :belongings, dependent: :destroy
  has_many :payments, dependent: :destroy
  belongs_to :plan

  validates :place, presence: true,
                    length: {maximum: 255}
  validates :plan_id, presence: true

end
