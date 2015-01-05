rack_env = ENV['RACK_ENV'] || 'production'

app_root = File.expand_path("../", __FILE__)
app_name = 'bbs'

# Use at least one worker per core if you're on a dedicated server,
# more will usually help for _short_ waits on databases/caches.
worker_processes (rack_env == 'production' ? 2 : 1)

working_directory app_root

# listen on both a Unix domain socket and a TCP port,
# we use a shorter backlog for quicker failover when busy
#listen "#{app_root}/tmp/#{app_name}.sock", :backlog => 64
listen 8090, :tcp_nopush => false

# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 30

# App ID
pid "#{app_root}/pids/#{app_name}.pid"

stderr_path "#{app_root}/log/#{app_name}.stderr.log"
stdout_path "#{app_root}/log/#{app_name}.stdout.log"

# combine Ruby 2.0.0dev or REE with "preload_app true" for memory savings
# http://rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

# Enable this flag to have unicorn test client connections by writing the
# beginning of the HTTP headers before calling the application.  This
# prevents calling the application for connections that have disconnected
# while queued.  This is only guaranteed to detect clients on the same
# host unicorn runs on, and unlikely to detect disconnects even on a
# fast LAN.
check_client_connection true

before_fork do |server, worker|
  begin
    defined?(Sequel::Model) and Sequel::Model.db.disconnect
    defined?(PadrinoCache) and PadrinoCache.quit
  rescue Exception => e
    # Airbrake.notify(e)
    #RAILS_DEFAULT_LOGGER.error("Couldn't connect to Mongo Server")
  end
  old_pid = "#{app_root}/pids/#{app_name}.pid.oldbin"
   if File.exists?(old_pid) && old_pid != server.pid
     begin
       Process.kill("QUIT", File.read(old_pid).to_i)
     rescue Errno::ENOENT, Errno::ESRCH
     end
  end
end

after_fork do |server, worker|
  GC.disable
  begin
    # defined?(MongoMapper::Document) and MongoMapper.connection.connect
    # defined?(RedisWorker) and RedisWorker.client.reconnect
    # defined?(RedisCache) and RedisCache.client.reconnect
    # defined?(PadrinoCache) and PadrinoCache.client.reconnect
    # defined?(RedisSettings) and RedisSettings.client.reconnect
    # Sidekiq.configure_client do |config|
    #   config.redis = { :namespace => 'manage', :url => "redis://#{REDIS_HOST}:#{REDIS_PORT}/4" }
    # end
  rescue Exception => e
    # Airbrake.notify(e)
  end

end