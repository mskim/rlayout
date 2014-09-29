
require File.dirname(__FILE__) + "/../spec_helper"

describe 'ParagraphModel creation' do
  before do
    @pm = ParagraphModel.new
  end
  
  it 'should create ParagraphModel' do
    @pm.must_be_kind_of ParagraphModel
  end
  
  it 'should have markpu' do
    @pm.markup.must_equal 'p'
    @pm.string.must_equal ''
  end
end


__END__
describe 'create Paragraph' do
  before do
    options = {:string=>"This is a paragraph test string", :markup=>'title'}
    @para = Paragraph.new(nil, :para_data=>options)
  end
    
  it 'should create Paragraph' do
    @para.x.must_equal 0
    # @para.y.must_equal 0
    @para.width.must_equal 100
    if RUBY_ENGINE == 'macruby'
      @para.height.must_equal 57
    else
      @para.height.must_equal 100
    end
    @para.must_be_kind_of Paragraph
    @para.graphics.length.must_equal 1
    @para.graphics.first.must_be_kind_of Text
  end
  
  it 'should save paragraph' do
    pdf_path = File.dirname(__FILE__) + "/../output/paragraph_test.pdf"
    @para.save_pdf(pdf_path)
  end
end

