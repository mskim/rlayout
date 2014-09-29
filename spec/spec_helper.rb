#!/usr/bin/env ruby
# encoding: utf-8

# puts "RLayout test: Running on Ruby Version: #{RUBY_VERSION}"
unless RUBY_ENGINE == "macruby"
  require 'minitest'
  # require 'pry-rescue/minitest'
end

require 'minitest/autorun'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib') 
# $LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..') 
# $LOAD_PATH.unshift File.dirname(__FILE__), '../..'

require "rlayout"

include RLayout