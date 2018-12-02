# frozen_string_literal: true

require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'full title helper' do
    assert_equal full_title, 'Trapla'
    assert_equal full_title('Help'), 'Help | Trapla'
  end
end
