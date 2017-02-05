
require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

require 'minitest/autorun'
include RLayout

describe 'create MarathonTag' do
  before do
    @project_path = "/Users/mskim/demo_rjob/variables/marathon_tag"
    @project_path = "/Users/mskim/demo_rjob/variables/marathon_tag"
    @marathon      = MarathonTag.new(@project_path)
  end
  
  it 'should create MarathonTag' do
    assert @marathon.class ==MarathonTag
  end
  
  
end