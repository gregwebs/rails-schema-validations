ENV['RAILS_ENV'] = 'test'

require 'active_record'
require 'riot'
require 'riot/rails'

def __DIR__
  File.dirname(__FILE__)
end
require File.join(__DIR__, '..', 'lib', 'rails-schema-validations')
