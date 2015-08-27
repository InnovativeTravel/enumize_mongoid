$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'enumize_mongoid'
require 'mongoid'

Mongoid.load!('./spec/config/mongoid.yml', :test)
Mongoid.logger.level = Logger::FATAL
Mongo::Logger.logger.level = ::Logger::FATAL