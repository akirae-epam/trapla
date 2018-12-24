# frozen_string_literal: true

FactoryBot.define do
  factory :main_user, class: User do |_user|
    name { 'rspec user' }
    email { 'spec_test@email.com' }
    password_digest { '$2a$10$7aUAH/UgU8bUFwOYDPescOEPLbOtAD0ocFhwx4N6IzQAL7m9CfVle' }
    activated { true }
  end
end
