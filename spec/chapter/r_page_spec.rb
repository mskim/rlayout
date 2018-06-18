require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"
include RLayout

describe "create a Page" do
  before do
    @page = RPage.new
  end

  it 'should create Page' do
    @page.must_be_kind_of RPage
  end

  it 'shoud have widht' do
    @page.width.must_equal SIZES['A4'][0]
  end

  it 'shoud create main_box' do
    @page.main_box.must_be_kind_of RTextBox
  end

end
