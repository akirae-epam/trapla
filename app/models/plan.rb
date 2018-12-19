# frozen_string_literal: true

class Plan < ApplicationRecord
  attr_accessor :remember_year, :remember_day

  has_many :plan_details, dependent: :destroy, inverse_of: :plan
  belongs_to :user, inverse_of: :plans
  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :title, presence: true
  validates :content, length: { maximum: 255 },
                      presence: true

  # 最後に描写した日時を記録する
  def remember_date(date, format)
    self.remember_year = date if format == 'year'
    self.remember_day = date if format == 'day'
  end
end
