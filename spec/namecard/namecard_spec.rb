require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"
describe "create Namecard" do
  before do
    @document_path = "/Users/mskim/test_data/namecard"
    FileUtils.mkdir_p(@document_path) unless File.exist?(@document_path)
    @card = RLayout::Namecard.new(document_path: @document_path, custom_style: true)
  end

  it 'should create Chapter' do
    assert_equal RLayout::CardMaker, @card.class 
  end

  # it 'should save PDF' do
  #   @pdf_path = "/Users/mskim/test_data/card_maker/chapter.pdf"
  #   assert File.exist?(@pdf_path)
  #   system("open #{@pdf_path}")
  # end
end
