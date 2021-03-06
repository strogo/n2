require 'yaml'

rails_root = ENV['RAILS_ROOT'] || File.expand_path(File.dirname(__FILE__) + '/../..')
rails_env = ENV['RAILS_ENV'] || 'development'

resque_config = YAML.load_file(rails_root + '/config/resque.yml')
Resque.redis = resque_config[rails_env]

app_name = rails_root =~ %r(/([^/]+)/(current|release)) ? $1 : nil
Resque.redis.namespace = "resque:#{app_name}" if app_name

begin
  NotificationWorker.class
  PFEED_RESQUE_KLASS = NotificationWorker
rescue NameError
end
