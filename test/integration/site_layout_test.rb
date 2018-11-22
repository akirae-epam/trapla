require 'test_helper'
class SiteLayoutTest < ActionDispatch::IntegrationTest
 def setup
   @user = users(:michael)
 end

 test "layout links" do
   get root_path
   assert_template 'static_pages/home'
   assert_select 'a[href=?]', root_path, count:2
   assert_select 'a[href=?]', about_path
   assert_select 'a[href=?]', help_path
   assert_select 'a[href=?]', signup_path, count:2
   assert_select 'a[href=?]', login_path, count:2
   get about_path
   assert_select "title", full_title("About")
 end

end
