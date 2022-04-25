require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create Prologue' do
  before do
    @document_path  = "#{ENV["HOME"]}/test_data/isbn"
    @pdf_path = "#{ENV["HOME"]}/test_data/isbn/chapter.pdf"
    FileUtils.mkdir_p(@document_path) unless File.exist?(@document_path)
    @prologue = Isbn.new(document_path: @document_path)
  end

  it 'should create FrontWing' do
    assert File.exist?(@pdf_path) 
    system "open #{@pdf_path}"
  end
end
