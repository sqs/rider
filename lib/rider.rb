$:.unshift File.dirname(__FILE__)

RIDER_DEBUG = true unless defined?(RIDER_DEBUG)

require 'rubygems'
require 'logger'
require 'mechanize'

require 'rider/queue'
require 'rider/crawler'

$KCODE = 'u'

module Rider
  VERSION = '0.1'
  LOGGER = Logger.new(STDOUT)
  LOGGER.level = Logger::INFO
  
  
  def log
    LOGGER
  end
  module_function :log
end