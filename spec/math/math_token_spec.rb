require File.dirname(__FILE__) + "/../spec_helper"


describe 'create Sqrt' do
  before do
    @token = MathToken.create_math_token(nil, {over: ["a" , "b"]})
  end
  
  it 'should create math_token' do
    assert @token.class == Over
  end
end

__END__
describe 'create Limit' do
  before do
    @token = MathToken.create_math_token(nil, {lim: [{from: 0}, {to: 4}, {sup: "x"}]})
  end
  
  it 'should create math_token' do
    assert @token.class == Limit
  end
end

describe 'create Over' do
  before do
    @token = MathToken.create_math_token(nil, {over: ["a" , "b"]})
  end
  
  it 'should create math_token' do
    assert @token.class == Over
  end
end
