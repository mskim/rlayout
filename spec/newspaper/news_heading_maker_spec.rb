require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'create NewsHeadingMaker' do
  before do
    @heading_path = "/Users/mskim/Development/rails4/newsman/public/heading/1"
    @hm  = NewsHeadingMaker.new(heading_path: @heading_path)
  end

  it 'shold create NewsHeadingMaker' do
    assert @hm.class == NewsHeadingMaker
  end
  it 'should create NewsHeading' do
    assert @hm.heading.class == NewsHeading
  end
end
