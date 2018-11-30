class Payment < ApplicationRecord
  belongs_to :plan_detail

  validates :plan_detail_id, presence: true
end
