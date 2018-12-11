# frozen_string_literal: true

class PlanDetail < ApplicationRecord
  belongs_to :plan

  VALID_DATE_REGEX = /\A\d{4}\/\d{2}\/\d{2}\s\d{2}:\d{2}\z/i
  validates :place, presence: true,
                    length: { maximum: 25 }
  validates :date, presence: true
end
