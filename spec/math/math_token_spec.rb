require File.dirname(__FILE__) + "/../spec_helper"


describe 'create Over Token' do
  before do
    @token  = MathToken.create_math_token({over: ["a" , "b"]})
    @token2 = MathToken.create_math_token({over: ["A" , "B"]})
  end
  
  it 'should set right font for capital and lower letter' do
    assert @token.class == Over
    assert @token.font  == "STkboNB"
    assert @token2.font == "STkboNA"
  end
end

__END__
describe 'create Limit' do
  before do
    @token = MathToken.create_math_token({lim: [{from: 0}, {to: 4}, {sup: "x"}]})
  end
  
  it 'should create math_token' do
    assert @token.class == Limit
  end
end

describe 'create Over' do
  before do
    @token = MathToken.create_math_token({over: ["a" , "b"]})
  end
  
  it 'should create math_token' do
    assert @token.class == Over
  end
end
ㅁ