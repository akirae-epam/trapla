require 'test_helper'

class PlansControllerTest < ActionDispatch::IntegrationTest
    def setup
      @plan = plans(:one)
    end

    test "should redirect create when not logged in" do
      assert_no_difference 'Plan.count' do
        post plans_path, params: { Plan: { title: 'title test', content: "content test" } }
      end
      assert_redirected_to login_url
    end

    test "should redirect destroy when not logged in" do
      assert_no_difference 'Plan.count' do
        delete plan_path(@plan)
      end
      assert_redirected_to login_url
    end
end
