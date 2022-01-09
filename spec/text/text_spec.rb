require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"


describe 'shoud save pdf text' do
  before do
          # text('This is  very long string and I like it\nthis is the second line.', x: 464.0, y: 4, font: 'Shinmoon',  font_size: 20, text_color: 'CMYK=0,0,0,100', text_alignment: 'center')
    @t = RLayout::Text.new(text_string: '번 123 일번', width: 500,font: 'Shinmoon',  font_size: 20, text_color: 'CMYK=0,0,0,100', text_alignment: 'center')
    @pdf_path = "/Users/Shared/rlayout/pdf_output/text/text.pdf"
  end

  it 'should save pdf' do
    @t.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    system "open #{@pdf_path}"
  end
end

__END__

# describe 'text_drawing test' do
#   before do
#     @text = Text.new(:text_string=> "This is text string.")
#     @path = "/Users/Shared/rlayout/output/text_drawing_test.svg"
#   end

#   it 'should create Text object' do
#     @text.must_be_kind_of Text
#   end
# end

# describe 'text_drawing test' do
#   before do
#     @text = Text.new(:text_string=> "This is text string.", x: 0, y:5, font: 'KoPubDotumPB', font_size: 12, width: 170, left_margin: 0, left_inset: 0)
#   end

#   it 'should create Text object' do
#     @text.must_be_kind_of Text
#   end
# end
