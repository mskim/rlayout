require File.dirname(__FILE__) + "/../spec_helper"


describe 'create new magazine' do
  before do
    @path = "/Users/mskim/magazine_article"
    @book = Magazine.new(path: @path)
  end

  it 'should create Magazine' do
    @book.must_be_kind_of Magazine
  end

  it 'should create a folder ' do
    File.exists?(@path).must_equal true
  end
  
end

describe 'create toc' do
  before do
    @path = "/Users/mskim/magazine_article"
    @book = Magazine.create_toc(@path)
  end

  it 'should create toc' do
    toc_path = @path + "/toc/toc.md"
    assert File.exist?(toc_path)
  end

end
