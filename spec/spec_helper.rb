#!/usr/bin/env ruby
# encoding: utf-8

# puts "RLayout test: Running on Ruby Version: #{RUBY_VERSION}"
require 'minitest'
require 'minitest/autorun'
# require 'pry-rescue/minitest'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib') 
# $LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..') 
# $LOAD_PATH.unshift File.dirname(__FILE__), '../..'

require "rlayout"

include RLayout