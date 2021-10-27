require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create Paperback' do
  before do
    @project_path  = "/Users/mskim/test_data/book/paperback"
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
