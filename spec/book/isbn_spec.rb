require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create Prologue' do
  before do
    @document_path  = "#{ENV["HOME"]}/test_data/isbn"
    @pdf_path = "#{ENV["HOME"]}/test_data/isbn/chapter.pdf"
    FileUtils.mkdir_p(@document_path) unless File.exist?(@document_path)
    h = {}
    h[:document_path] = @document_path
    h[:width] = SIZES['A4'][0]
    h[:height] = SIZES['A4'][1]
    h[:left_margin] = 50
    h[:top_margin] = 50
    h[:right_margin] = 50
    h[:bottom_margin] = 50

    @prologue = Isbn.new(**h)
  end

  it 'should create FrontWing' do
    assert File.exist?(@pdf_path) 
    system "open #{@pdf_path}"
  end
end
