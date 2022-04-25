require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"
describe "create CardStepAndRepeat" do
  before do
    @card_path = "#{ENV["HOME"]}/test_data/namecard/members/sample.pdf"
    # FileUtils.mkdir_p(@document_path) unless File.exist?(@document_path)
    @card_snp = RLayout::CardStepAndRepeat.new(@card_path)
  end

  it 'should create CardStepAndRepeat' do
    assert_equal RLayout::CardStepAndRepeat, @card_snp.class
  end

end
