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

  test 'should follow and unfollow a user' do
    michael = users(:michael)
    archer  = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
    assert_not archer.followers.include?(michael)
  end

  test 'feed should have the right posts' do
    michael = users(:michael)
    archer  = users(:archer)
    lana    = users(:lana)
    # フォローしているユーザーの投稿を確認
    lana.plans.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # 自分自身の投稿を確認
    michael.plans.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    # フォローしていないユーザーの投稿を確認
    archer.plans.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end
end
