require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create Paperback' do
  before do
    # @project_path  = "/Users/mskim/test_data/book/paperback"
    @project_path  = "/Users/Shared/bookcheego/mskimsid@gmail.com/2021-11-03_11\:10\:56_+0900"
    @paperback = Paperback.new(@project_path)
  end

  it 'should create Seneca' do
    assert_equal RLayout::Paperback, @paperback.class 
  end

  # it 'should create Seneca' do
  #   assert File.exist?(@pdf_path) 
  #   system "open #{@pdf_path}"
  # end
end
