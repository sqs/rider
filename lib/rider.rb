$:.unshift File.dirname(__FILE__)

RIDER_DEBUG = true unless defined?(RIDER_DEBUG)

require 'rubygems'
require 'logger'
require 'mechanize'

require 'rider/debug'
require 'rider/queue'
require 'rider/crawler'

$KCODE = 'u'

include Rider::Debug

module Rider
  VERSION = '0.1'
end