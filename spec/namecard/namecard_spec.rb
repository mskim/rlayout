require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"
describe "create Namecard" do
  before do
    @project_path = "#{ENV["HOME"]}/test_data/namecard"
    FileUtils.mkdir_p(@project_path) unless File.exist?(@project_path)
    @card = RLayout::Namecard.new(@project_path)
  end

  it 'should create Namecard' do
    assert_equal RLayout::Namecard, @card.class 
  end

end
