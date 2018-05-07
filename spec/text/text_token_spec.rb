
require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create  TextToken' do
  before do
    @string1 = 'end.'
    @string2 = 'end?'
    @string3 = 'end,'
    @string4 = 'end!'
  end


  it 'should detect ' do
    assert_equal 3, @string1 =~/[\.|\?|\,|!]$/
    assert_equal 3, @string2 =~/[\.|\?|\,|!]$/
    assert_equal 3, @string3 =~/[\.|\?|\,|!]$/
    assert_equal 3, @string4 =~/[\.|\?|\,|!]$/
  end


end

__END__
describe 'create  TextToken' do
  before do
    @text_string    = "This is number of differently labeled segments we use vary."
    @para           = Paragraph.new(para_string: @text_string, markup: "p")
    @para.tokens.each do |t|
      puts t.string.dump
      puts t.width
    end
  end

  it 'should create right number of tokens' do
    @para.tokens.length.must_equal 10
  end

end

describe 'create special TextToken' do
  before do
    @text_string    = "1	{The} number of differently labeled segments we use vary."
    @para           = Paragraph.new(para_string: @text_string, markup: "p")
    @para.tokens.each do |t|
      puts t.string.dump
    end
  end

  it 'should create right number of tokens' do
    assert_equal @para.tokens.length, 11
  end

end

__END__
describe 'create special TextToken' do
  before do
    @text_string    = "This is a {{subject}{s}} {second}\n{{third}}String"
    @text_string    = "1	{The} number of differently labeled segments we use vary."
    @para           = Paragraph.new(para_string: @text_string, markup: "p")
    @para.tokens.each do |t|
      puts t.class
    end
  end

  it 'should create right number of tokens' do
    assert_equal @para.tokens.length, 7
  end

  it 'should create special Token' do
    assert_equal @para.tokens[1].class, TextToken
    assert_equal @para.tokens[0].stroke[:sides], [1,1,1,1]
    assert_equal @para.tokens[0].stroke[:thickness], 0
    assert_equal @para.tokens[3].class, ReverseRubyToken
    assert_equal @para.tokens[4].class, TextToken
    assert_equal @para.tokens[4].stroke[:sides], [0,1,0,1]
    assert_equal @para.tokens[4].stroke[:thickness], 0.5
    assert_equal @para.tokens[5].class, TextToken
    assert_equal @para.tokens[5].stroke[:sides], [1,1,1,1]
    assert_equal @para.tokens[5].stroke[:thickness], 0.5
  end
end

__END__
describe 'create TextToken' do
  before do
    @text_string    = "This is a {{double}} String"
    @para           = Paragraph.new(para_string: @text_string, markup: "p")
  end

  it 'should create Paragraph' do
    assert_equal @para.class, Paragraph
    assert_equal @para.tokens.length, 5
  end

  it 'should create TextToken' do
    assert_equal @para.tokens.first.class, TextToken
  end

  it 'should create special Token' do
    skip "assert_equal @para.tokens[1].class, TabToken"

  end
end
