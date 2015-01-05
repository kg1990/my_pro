Sequel::Model.plugin(:schema)
Sequel::Model.raise_on_save_failure = false # Do not throw exceptions on failure
Sequel::Model.db = DB = Sequel.postgres(:host => '192.168.2.126',
                                         :user => 'yeeshop',
                                         :password => '123456',
                                         :database => 'youhaosuda_bbs',
                                         :max_connections => 5,
                                         :pool_timeout => 5,
                                         :servers=>{:read_only=>{:host=>'192.168.2.126'}})

REDIS_HOST,REDIS_PORT = '127.0.0.1', 6379

RedisCache = Redis.new(:host => REDIS_HOST, :port => REDIS_PORT, :db => 1)
RedisWorker = Redis.new(:host => REDIS_HOST, :port => REDIS_PORT, :db => 2)

Sidekiq.configure_server do |config|
  config.redis = { :namespace => 'bbs', :url => "redis://#{REDIS_HOST}:#{REDIS_PORT}/4" }
end

Sidekiq.configure_client do |config|
  config.redis = { :namespace => 'bbs', :url => "redis://#{REDIS_HOST}:#{REDIS_PORT}/4" }
end

# MongoMapper.setup({
#   'production' => {
#   'hosts' => ['192.168.2.128:27017','192.168.2.129:27017']
#   }}, 'production', :read_secondary => false, :pool_size => 5, :pool_timeout => 5)

# Sidekiq.configure_server do |config|
#   config.redis = { :namespace => 'bbs', :url => "redis://#{REDIS_HOST}:#{REDIS_PORT}/4" }
#   config.error_handlers << Proc.new {|ex,ctx_hash| Airbrake.notify(ex) }
# end

# Sidekiq.configure_client do |config|
#   config.redis = { :namespace => 'bbs', :url => "redis://#{REDIS_HOST}:#{REDIS_PORT}/4" }
# end

# Sequel::Model.db = case Padrino.env
#   when :development then Sequel.connect("postgres://localhost/bbs_development", :loggers => [logger])
#   when :production  then Sequel.connect("postgres://localhost/bbs_production",  :loggers => [logger])
#   when :test        then Sequel.connect("postgres://localhost/bbs_test",        :loggers => [logger])
# end
