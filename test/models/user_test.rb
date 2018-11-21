require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name:'validename',
                     email:'valid@email.com',
                     password: 'foobar',
                     password_confirmation: 'foobar')
  end

  test "valid user infomation" do
    assert @user.valid?
  end

  test "name or email should not be blank" do
    user = User.new(name:'', email:'')
    assert_not user.valid?
    assert_not user.errors.messages[:name].empty?
    assert_not user.errors.messages[:email].empty?
  end

  test "name.length should be less than 26 charactors)" do
    name = 'a' * 26
    user = User.new(name: name, email:@user.email)
    assert_not user.valid?
    assert_not user.errors.messages[:name].empty?
  end

  test "email.length should be less than 255 charactors)" do
    mail = ('a' * 246) + '@email.com'
    user = User.new(name: @user.name, email:mail)
    assert_not user.valid?
    assert_not user.errors.messages[:email].empty?
  end

  test "email should be valid format" do
    user = User.new(name: @user.name, email:'invalid')
    assert_not user.valid?
    assert_not user.errors.messages[:email].empty?
  end

  test "name and email should be uniqueness" do
    assert @user.valid?
    @user.save

    user = User.new(name: @user.name,
                    email:'valid2@email.com',
                    password: @user.password,
                    password_confirmation: @user.password_confirmation)
    assert_not user.valid?
    assert_not user.errors.messages[:name].empty?

    user = User.new(name:'validename2',
                    email: @user.email,
                    password: @user.password,
                    password_confirmation: @user.password_confirmation)
    assert_not user.valid?
    assert_not user.errors.messages[:email].empty?
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end
