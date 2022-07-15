require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create LatexToken' do
  before do
    # @math = LatexToken.new(latex_string: "\\sqrt{x^2+y^2+z^2}")
    # notice that I am using single quote 
    # single quoted string treats back slash as \
    # where as in docule quoted string it treats as escaped back slash
    @math = LatexToken.new(latex_string: '\frac{a}{\sqrt{x}}')
  end
  
  it 'should create LatexToken' do
    assert @math.class == LatexToken
  end
  
  it 'should create image_path' do
    assert_equal @math.image_path,  '!frac{a}{!sqrt{x}}.pdf'
  end
   
end


describe 'create LatexToken' do
  before do
    # @math = LatexToken.new(latex_string: "\\sqrt{x^2+y^2+z^2}")
    # notice that I am using single quote 
    # single quoted string treats back slash as \
    # where as in docule quoted string it treats as escaped back slash
    @math = LatexToken.new(latex_string: '\frac{a}{\sqrt{x+1}}')
  end
  
  it 'should create LatexToken' do
    assert @math.class == LatexToken
  end
  
  it 'should create image_path' do
    assert_equal @math.image_path, '!frac{a}{!sqrt{x+1}}.pdf'
  end
   
end