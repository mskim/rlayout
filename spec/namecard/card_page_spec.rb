require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"
describe "create CardPage" do
  before do
    @document_path = "#{ENV["HOME"]}/test_data/card_front"
    @pdf_path = "#{ENV["HOME"]}/test_data/card_page/card_page.pdf"
    FileUtils.mkdir_p(@document_path) unless File.exist?(@document_path)
    @card_front = RLayout::CardPage.new(document_path: @document_path) do 
      logo([1,1,1,1])
      personal([5,0,7,3])
      company([2,3,10,3])
    end
  end

  it 'should create CardPage' do
    assert_equal RLayout::CardPage, @card_front.class 
  end

  it 'should save PDF' do
    @card_front.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    system("open #{@pdf_path}")
  end
end
