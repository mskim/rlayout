require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"
include RLayout

describe "create RDocument" do
  before do
    @doc = RDocument.new()
  end

  it 'should create RDocument' do
    @doc.must_be_kind_of RDocument
  end

  it 'should have a title' do
    @doc.title.must_equal 'untitled'
  end

  it 'should have a paper_size' do
    @doc.paper_size.must_equal 'A4'
  end

  it 'shoud have widht' do
    @doc.width.must_equal SIZES['A4'][0]
  end

  it 'should have pages' do
    @doc.pages.length.must_equal 1
  end

  it 'should have margins' do
    @doc.left_margin.must_equal 50
  end
end

describe "create first page" do
  before do
    @doc = RDocument.new()
    @pages = @doc.pages
    @first_page = @pages.first
  end

  it 'should create a first page' do
    @pages.length.must_equal 1
  end

  it 'should create a first page' do
    @pages.first.must_be_kind_of RPage
  end

  it 'should create a first page' do
    @first_page.must_be_kind_of RPage
  end

end
