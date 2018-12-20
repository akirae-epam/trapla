# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.5.1'

gem 'activestorage' # active strageを使う
gem 'bcrypt', '3.1.12' # パスワード(password_digest)をハッシュ化する
gem 'bootstrap-sass', '3.3.7' # bootstrap用
gem 'bootstrap-will_paginate', '1.0.0' # ページネーションでbootstrap
gem 'bootstrap3-datetimepicker-rails' # 入力フォームにdatepickerを使用
gem 'coffee-rails', '4.2.2'
gem 'faker', '1.7.3' # サンプルデータを作成する
gem 'jbuilder', '2.7.0'
gem 'jquery-rails', '4.3.1' # jqueryを使用する
gem 'mail-iso-2022-jp' # メイラーで送る文章の日本語化
gem 'mini_magick' # 画像をアップロードする
gem 'mini_racer'
gem 'momentjs-rails', '~> 2.9', github: 'derekprior/momentjs-rails' # 入力フォームにdatepickerを使用（時間）
gem 'mysql2'
gem 'puma', '3.9.1'
gem 'rails', '5.2.0'
gem 'sass-rails', '5.0.6' # bootstrap用
gem 'turbolinks', '5.0.1'
gem 'uglifier', '3.2.0'
gem 'will_paginate', '3.1.6' # ページネーション

group :development, :test do
  gem 'byebug', '9.0.6', platform: :mri
  gem 'pry-rails'
  gem 'rubocop', require: false
end

group :development do
  gem 'erb_lint', require: false
  gem 'listen', '3.1.5'
  gem 'scss_lint', require: false
  gem 'spring',                '2.0.2'
  gem 'spring-watcher-listen', '2.0.1'
  gem 'web-console',           '3.5.1'
end

group :test do
  gem 'guard',                    '2.13.0'
  gem 'guard-minitest',           '2.4.4'
  gem 'minitest',                 '5.10.3'
  gem 'minitest-reporters',       '1.1.14'
  gem 'rails-controller-testing', '1.0.2'
end

group :production do
  gem 'unicorn'
end
