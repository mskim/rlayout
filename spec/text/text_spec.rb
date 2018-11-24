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

describe 'shoud fit_box_to_text' do
  before do
    @c =  RLayout::Container.new(width: 1028.976498, height: 41.70979114285714, layout_direction: 'horinoztal') do
          text('전 면 광 고', x: 464.0, y: -4, width: 100, font: 'KoPubBatangPM',  font_size: 20, text_color: CMYK=0,0,0,100, text_alignment: 'center', fill_color:'clear', text_fit_type: 'fit_box_to_text', anchor_type: 'center_anchor')
        end
    @text = @c.graphics.first
  end

  it 'should create Container object' do
    @text.must_be_kind_of Text
  end

  it 'should fit width box to text' do
    @text.width.to_i.must_equal 56
  end

  it 'should fit width box to text' do
    @text.text_fit_type.must_equal 'fit_box_to_text'
    @text.anchor_type.must_equal 'center_anchor'
  end
end


# describe 'shoud fit_box_to_text' do
#   before do
#     @text = Text.new(:text_string=> "This is text string.", :fit_box_to_text=> true, :center_anchor=> true)
#     @path = "/Users/Shared/rlayout/output/text_drawing_test.svg"
#   end

#   it 'should create Text object' do
#     @text.width.must_equal 92.666015625
#   end

# end

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
