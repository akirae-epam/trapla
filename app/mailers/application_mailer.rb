# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@example.com', charset: 'ISO-2022-JP'
  layout 'mailer'
end
