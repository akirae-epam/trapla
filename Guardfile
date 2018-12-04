# frozen_string_literal: true

guard :minitest, spring: 'bin/rails test', all_on_start: false do
  # with Minitest::Unit
  watch(%r{^test/(.*)\/?test_(.*)\.rb$})
  watch(%r{^lib/(.*/)?([^/]+)\.rb$})     { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  watch(%r{^test/test_helper\.rb$})      { 'test' }
end

# 与えられたリソースに対応する統合テストを返す
def integration_tests(resource = :all)
  if resource == :all
    Dir['test/integration/*'] else
                                Dir["test/integration/#{resource}_*.rb"]
  end
end

# 与えられたリソースに対応するコントローラのテストを返す
def controller_test(resource)
  "test/controllers/#{resource}_controller_test.rb"
end

# 与えられたリソースに対応するすべてのテストを返す
def resource_tests(resource)
  integration_tests(resource) << controller_test(resource)
end
