require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create Prologue' do
  before do
    @document_path  = "#{ENV["HOME"]}/test_data/prologue"
    @pdf_path = "#{ENV["HOME"]}/test_data/prologue/chapter.pdf"
    @prologue = Prologue.new(document_path: @document_path, custom_style:true)
  end

  it 'should create FrontWing' do
    assert_equal RLayout::Prologue, @prologue.class 
  end

  it 'should create FrontWing' do
    assert File.exist?(@pdf_path) 
    system "open #{@pdf_path}"
  end
end
