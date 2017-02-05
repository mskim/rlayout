require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create SinglePageMaker' do
  before do
    @path = "/Users/mskim/dorok/1"
    @sp = SinglePageMaker.new(@path)
  end

  it ' should create SinglePageMaker' do
    @sp.must_be_kind_of SinglePageMaker
  end
  
  it ' should have first_text_box' do
    @tb = @sp.page.first_text_box
    @tb.must_be_kind_of TextBox
  end

end
