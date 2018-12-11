# frozen_string_literal: true

class PlanDetail < ApplicationRecord
  belongs_to :plan

  validates :place, presence: true,
                    length: { maximum: 50 }
  validates :date, presence: true
end
