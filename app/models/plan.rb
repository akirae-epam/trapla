# frozen_string_literal: true

class Plan < ApplicationRecord
  has_many :plan_details, dependent: :destroy
  belongs_to :user
  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :title, presence: true
  validates :content, length: { maximum: 140 }
end
