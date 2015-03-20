require File.dirname(__FILE__) + "/../spec_helper"


describe 'RJob Testing' do
  before do
    @path = "/Users/mskim/rjob_samples/SoftwareLab.rlayout"
    @job = RJob.new(@path)
  end
  
  it 'should create RJob' do
    @job.must_be_kind_of RJob
    @job.valid_job?.must_equal true
  end
end