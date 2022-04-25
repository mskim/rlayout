require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"
describe "create Namecard" do
  before do
    @document_path = "#{ENV["HOME"]}/test_data/namecard"
    FileUtils.mkdir_p(@document_path) unless File.exist?(@document_path)
    @card = RLayout::Namecard.new(document_path: @document_path)
  end

  it 'should create Namecard' do
    assert_equal RLayout::Namecard, @card.class 
  end

end
