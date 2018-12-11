# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'valid name',
                     email: 'valid@email.com',
                     password: 'foobar',
                     password_confirmation: 'foobar')
    @valid_name = 'valid name'
    @valid_email = 'valid@email.com'
    @valid_password = 'foobaer'
  end

  test 'valid user infomation' do
    assert @user.valid?
  end

  test 'name or email should not be blank' do
    @user.name = ''
    @user.email = ''
    assert_not @user.valid?
    assert_not @user.errors.messages[:name].empty?
    assert_not @user.errors.messages[:email].empty?
  end

  test 'name.length should be less than 26 charactors)' do
    name = 'a' * 26
    @user.name = name
    assert_not @user.valid?
    assert_not @user.errors.messages[:name].empty?
  end

  test 'email.length should be less than 255 charactors)' do
    mail = ('a' * 246) + '@email.com'
    @user.email = mail
    assert_not @user.valid?
    assert_not @user.errors.messages[:email].empty?
  end

  test 'email should be valid format' do
    @user.email = 'invalid'
    assert_not @user.valid?
    assert_not @user.errors.messages[:email].empty?
  end

  test 'name and email should be uniqueness' do
    assert @user.valid?
    @user.save

    # ユーザ名がかぶったらエラー
    user = User.new(name: @valid_name,
                    email: 'valid2@email.com',
                    password: @valid_password,
                    password_confirmation: @valid_password)
    assert_not user.valid?
    assert_not user.errors.messages[:name].empty?

    # メールアドレスがかぶったらエラー
    user = User.new(name: 'valid name2',
                    email: @valid_email,
                    password: @valid_password,
                    password_confirmation: @valid_password)
    assert_not user.valid?
    assert_not user.errors.messages[:email].empty?
  end

  test 'password should be present (nonblank)' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test 'password should have a minimum length' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end

  test 'authenticated? should return false for a user with nil digest' do
    assert_not @user.token_authenticated?(:remember, '')
  end

  test 'associated microposts should be destroyed' do
    @user.save
    @user.plans.create!(title: 'Title test', content: 'Lorem ipsum')
    assert_difference 'Plan.count', -1 do
      @user.destroy
    end
  end
end
