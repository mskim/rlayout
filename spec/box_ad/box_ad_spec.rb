require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe "create BoxAd" do
  before do
    @svg_path     = "/Users/mskim/test_data/box_ad/output.svg"
    @pdf_path     = "/Users/mskim/test_data/box_ad/output.pdf"
    @ad_content  = {
      title: "This is title",
      subtitle: "This is subtitle",
      body: "This is a body text. And this is the second line.",
      list: "This is a body text. And this is the second line.",
      email: "steve@apple.com",
      phone: "H.P 010-444-5555",
      address: "144 Some St New York N.Y."
    }
    @box_ad       = RLayout::BoxAd.new(width: 200, height: 300, ad_content: @ad_content)
  end

  it 'should create BoxAd' do
    assert_equal BoxAd, @box_ad.class 
  end

  it 'should have graphics' do
    assert_equal 3, @box_ad.graphics.length
  end

  it 'should save svg' do
    @box_ad.save_pdf_with_ruby(@pdf_path)
    assert File.exist?(@pdf_path) == true
    system "open #{@pdf_path}"
  end
end