require File.dirname(__FILE__) + "/../spec_helper"

describe 'parse braced eqn' do

  it 'should parse over' do
    @eq_1 = EQNParser.new("{a + b} over sqrt xyz ")
    assert @eq_1.hash   == {:over=>[["a", "+", "b"], {:sqrt=>"xyz"}]}
  end
  
  it 'should parse sum' do
    @eq = EQNParser.new("sum from 2 to infinte 1 over sqrt xyz + 32 over 24 sup 2")
    assert @eq.hash   == [{:sum=>[{:from=>"2"}, {:to=>"infinte"}, {:over=>["1", {:sqrt=>"xyz"}]}]} ,'+', {:over=>["32", {:sup=>["24", "2"]}]}]
  end
  
  it 'should parse int' do
    @eq = EQNParser.new("int from 2 to n=14 1 over sqrt xyz + 32 over 24 sup 2")
    assert @eq.hash   == [{:int=>[{:from=>"2"}, {:to=>"n=14"}, {:over=>["1", {:sqrt=>"xyz"}]}]} ,'+', {:over=>["32", {:sup=>["24", "2"]}]}]
  end
  
  it 'should parse lim' do
    @eq = EQNParser.new("lim from 2 to n=14 1 over sqrt xyz + 32 over 24 sup 2")
    assert @eq.hash   == [{:lim=>[{:from=>"2"}, {:to=>"n=14"}, {:over=>["1", {:sqrt=>"xyz"}]}]} ,'+', {:over=>["32", {:sup=>["24", "2"]}]}]
  end
     
end
