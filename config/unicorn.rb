# frozen_string_literal: true

worker_processes Integer(ENV['WEB_CONCURRENCY'] || 3)
timeout 15
preload_app true

listen '/usr/src/appdir/tmp/sockets/unicorn.sock'
pid    '/usr/src/appdir/tmp/sockets/unicorn.pid'

before_fork do |_server, _worker|
  Signal.trap 'TERM' do
    Rails.logger.debug 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) && ActiveRecord::Base.connection.disconnect!
end

after_fork do |_server, _worker|
  Signal.trap 'TERM' do
    Rails.logger.debug 'Unicorn worker intercepting TERM and doing nothing.'
    Rails.logger.debug 'Wait for master to send QUIT.'
  end

  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
end

stderr_path File.expand_path('/usr/src/appdir/log/unicorn.log', ENV['RAILS_ROOT'])
stdout_path File.expand_path('/usr/src/appdir/log/unicorn.log', ENV['RAILS_ROOT'])
