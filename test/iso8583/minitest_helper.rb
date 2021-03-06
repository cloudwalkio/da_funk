if ENV['COV']
  require 'simplecov'
  SimpleCov.start
end

require 'byebug'
require 'minitest/autorun'
PROJECT_ROOT = File.join(File.dirname(File.expand_path(__FILE__)), '..', '..')
Dir.glob(File.join(PROJECT_ROOT, 'lib', 'iso8583', '**', '*.rb')).each do |file|
  require file
end
