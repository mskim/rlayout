require File.dirname(__FILE__) + "/../spec_helper"

describe 'GlossaryMaker layout image' do
  before do
    template  = "/Users/Shared/SoftwareLab/article_template/glossary.rb"
    url       = "localhost:3000/words.json"
    story_path= "/Users/mskim/book/sample_book/1.chapter/sample.md"
    @doc      = GlossaryMaker.new(url: url)
  end
  
  it 'should create GlossaryMaker' do
    assert @doc.class == GlossaryMaker
  end
  
end

