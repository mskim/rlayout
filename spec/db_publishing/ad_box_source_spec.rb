require File.dirname(__FILE__) + "/../spec_helper"

describe 'sample ad' do
  before do
    @ad = AdBox.sample
    @ad.relayout!
    @pdf_path = "/Users/Shared/rlayout/output/ad_box_source_sample.pdf"
  end
  
  it 'should create AdBox' do
    @ad.must_be_kind_of AdBox
    @ad.graphics.length.must_equal 3
  end
  
  it 'shluld create 100 AdBoxes' do
    @ads = AdBox.samples_of(100)
    @ads.length.must_equal 100
  end
  
  it 'should save pdf' do
    @ad.save_pdf(@pdf_path)    
    File.exists?(@pdf_path).must_equal true
  end
end
