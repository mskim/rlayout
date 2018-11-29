require File.dirname(File.expand_path(__FILE__)) + "/../../spec_helper"

describe 'save pdf pdf in Ruby mode rectangle in Page' do
  before do
    @c = Page.new(x:0, y:0, width: 600, height: 800, stroke_width: 1, stroke_color:"CMYK=0,0,0,100", stroke_color: [0,0,0,0]) do
        text('This is text', x:0, y:100, font:'shinmoon', font_size:12, stroke_width: 5,)
        text('This is text', x:150, y:100, font:'KoPubBatangPM', font_size:18, stroke_width: 5,)
        text('This is text', x:300, y:100, font:'KoPubDotumPM', font_size:18, stroke_width: 5,)
        text('This is text', x:0, y:300, width: 500, font:'KoPubBatangPM', font_size:42, stroke_width: 5,)

      end
     @pdf_path = "/Users/Shared/rlayout/pdf_output/text.pdf"
  end

  it 'should save page' do
    @c.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    system "open #{@pdf_path}"
  end
end
