require File.dirname(File.expand_path(__FILE__)) + "/../../spec_helper"

describe 'create Graphic svg ' do
  before do
    @doc_path = "/Users/mskim/test_data/svg/chapter"
    @chapter = RChapter.new(document_path: @doc_path, paper_size: 'A4', svg: true)
  end

  it 'should save svg' do
    assert File.exist?(@doc_path)
    system "open #{@doc_path}"
  end
end
