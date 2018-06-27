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

describe "create a first_page" do
  before do
    @page = RPage.new(first_page: true)
    @main_box        = @page.main_box
    @heading_object   = @page.heading_object
  end

  it 'should create first_page' do
    @page.first_page.must_equal true
  end

  it 'should have main_text' do
    @main_box.must_be_kind_of RTextBox
  end

  it 'should have heading_object' do
    @page.heading_object.must_be_kind_of RHeading
  end

  it 'should have fixed h=ight' do
    @heading_object.height.must_equal 370.945
  end

  it 'main_box should have fixed h=ight' do
    @main_box.height.must_equal 370.945
  end

end
