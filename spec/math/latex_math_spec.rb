require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create LatexToken' do
  before do
    # @math = LatexToken.new(latex_string: "\\sqrt{x^2+y^2+z^2}")
    # notice that I amd using single quote 
    # single quoted string treats back slash as \
    # where as in docule quoted string it treats as escaped back slash
    @math = LatexToken.new(latex_string: '\frac {a} {\sqrt{x}}')
  end
  
  it 'should create LatexToken' do
    assert @math.class == LatexToken
  end
  
  it 'should create image_path' do
    assert @math.image_path == '/Users/Shared/SoftwareLab/math/lib/!frac{a}{!sqrt{x}}.pdf'
  end
   
end