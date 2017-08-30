require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'create caption paragraph' do
  before do
    @cp             = CaptionParagraph.new(caption_title: "caption title", caption: "this is caption first para. And this is the second paragraph", source: 'Source: UPS')
    @tokens         = @cp.tokens
    @source_tokens  = @cp.source_tokens

  end

  it 'should create CaptionParagraph' do
    assert_equal CaptionParagraph, @cp.class
    assert_equal "caption title", @cp.caption_title
    assert_equal "this is caption first para. And this is the second paragraph", @cp.caption
    assert_equal "Source: UPS", @cp.source
  end

  it 'should create token' do
    assert_equal Array, @tokens.class
    assert_equal 13, @tokens.length
    assert_equal 2, @source_tokens.length
  end
end
