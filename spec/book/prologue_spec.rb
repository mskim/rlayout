require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create Prologue' do
  before do
    @document_path  = "/Users/mskim/test_data/prologue"
    @pdf_path = "/Users/mskim/test_data/prologue/chapter.pdf"
    @prologue = Prologue.new(document_path: @document_path)
  end

  it 'should create FrontWing' do
    assert_equal RLayout::Prologue, @prologue.class 
  end

  it 'should create FrontWing' do
    assert File.exist?(@pdf_path) 
    system "open #{@pdf_path}"
  end
end