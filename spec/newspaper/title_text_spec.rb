require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'create TitleText' do
  before do
    @tt                 = TitleText.new(string: "this is a title", para_style_name:'title_4_5', width: 500)
    @line               = @tt.graphics.first
    @string
  end

  it 'should create TitleText' do
    assert_equal TitleText, @tt.class
    assert_equal 48, @tt.height
  end

  it 'should create one line' do
    assert_equal 4, @tt.graphics.length
  end
end
