# frozen_string_literal: true

class PlanDetail < ApplicationRecord
  belongs_to :plan

  validates :place, presence: true,
                    length: { maximum: 255 }
  validates :plan_id, presence: true
end
