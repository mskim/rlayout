require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe "Should create StepAndRepeatCard object" do
  before do
    @path="/Users/Shared/name_card/강민철.pdf"    
    @snr_path="/Users/Shared/name_card/snr__강민철.pdf"
    @snr_path = "/Users/mskim/Desktop/최정희.pdf";    
    @path= "/Users/mskim/Development/rails32/business_card/public/member_files/1/1.pdf"
    # @snr= StepAndRepeatCard.new(@path, @snr_path, "A3")
    @snr= StepAndRepeatCard.new(@path, @snr_path)
  end
  it 'should create object' do
    assert_kind_of(StepAndRepeatCard,@snr)
  end
  
  it 'should create StepPageView' do
    assert_kind_of(StepPageView,@snr.view)
  end
  
  it 'should create StepPageView' do
    @view=@snr.view
    assert_equal(3,@view.columns)
    assert_equal(8,@view.rows)
  end
  
  it 'should save pdf' do
    assert(File.exists?(@snr_path))
    system("open #{@snr_path}")
  end
end

