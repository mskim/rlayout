require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"
describe "create CardPage" do
  before do
    @document_path = "#{ENV["HOME"]}/test_data/card_page"
    @pdf_path = @document_path + "/card_page.pdf"
    @company_info =<<~EOF
    ---
    :company_name: 한국상사
    :phone: 02-135-5555
    :address_1: 서을특별시 중구 을지로
    :address_2: 135-5
    :en_company_name: Hankook Trading
    :en_address_1: 135-5 UljeeRo
    :en_address_2: Jung-GU Seoul, Korea 10033
    
    EOF
    FileUtils.mkdir_p(@document_path) unless File.exist?(@document_path)
    @card_front = RLayout::CardPage.new(document_path: @document_path) do 
      logo(1,1,1,1)
      personal(5,0,7,3)
      company(2,3,10,3)
    end
    @card_front.personal_info = {name: "Min Soo Kim"}
    @card_front.company_info = {company_name: "한국상사"}
    @card_front.set_content
    
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
