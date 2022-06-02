require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

# describe 'create Paperback from body.md' do
#   before do
#     # @project_path  = "#{ENV["HOME"]}/test_data/book/paperback"
#     # @project_path  = "/Users/mskim/Development/paperback_writer/paperback/public/job/mskimsid@gmail.com/소설-2"
#     @project_path  = "#{ENV["HOME"]}/test_data/book/paperback_with_book_md"
#     @paperback = Paperback.new(@project_path)
#   end

#   it 'should create Book' do
#     assert_equal RLayout::Paperback, @paperback.class 
#   end
# end

describe 'create Paperback from body.md' do
  before do
    @project_path  = "#{ENV["HOME"]}/test_data/paperback"
    FileUtils.mkdir_p(@project_path) unless File.exist?(@project_path)
    @paperback = Paperback.new(@project_path)
  end

  it 'should create Book' do
    assert_equal RLayout::Paperback, @paperback.class 
  end
end
# describe 'create Paperback' do
#   before do
#     # @project_path  = "#{ENV["HOME"]}/test_data/book/paperback"
#     @project_path  = "/Users/Shared/bookcheego/joyman23@gmail.com/소설"
#     @project_path  = "/Users/mskim/Development/paperback_writer/paperback/public/job/mskimsid@gmail.com/소설"
#     @project_path  = "/Users/mskim/Development/paperback_writer/paperback/public/job/mskimsid@gmail.com/소설"
#     @project_path  = "/Users/mskim/daebooklee/paperback"
#     @project_path  = "#{ENV["HOME"]}/test_data/book/paperback"
#     # @project_path  = "/Users/mskim/development/world_print/boy"
#     @paperback = Paperback.new(@project_path)
#   end

#   it 'should create Book' do
#     assert_equal RLayout::Paperback, @paperback.class 
#   end

#   # it 'should create Seneca' do
#   #   assert File.exist?(@pdf_path) 
#   #   system "open #{@pdf_path}"
#   # end
# end