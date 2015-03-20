require File.dirname(__FILE__) + "/../spec_helper"

require 'minitest/autorun'
include RLayout

describe 'RJob Testing' do
  before do
    @path = "/Users/mskim/rjob_samples/first.rjob"
    @job = RJob.new(@path)
  end
  
  it 'should create RJob' do
    @job.must_be_kind_of RJob
    @job.valid_job?.must_equal true
  end
end