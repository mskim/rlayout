require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create BookCover' do
  before do
    @project_path  = "/Users/mskim/test_data/book_cover_2"
    @pdf_path  = "/Users/mskim/test_data/book_cover_2/output.pdf"
    @book_cover = BookCover.new(project_path: @project_path, has_wing:true)
  end

  it 'should create BookCover' do
    assert_equal RLayout::BookCover, @book_cover.class 
  end

  it 'should have cover_spread' do
    assert_equal RLayout::CoverSpread, @book_cover.cover_spread.class
  end

  it 'should have back_wing' do
    # binding.pry
    assert_equal RLayout::BackWing, @book_cover.back_wing.class
  end

  it 'should have back_page' do
    # binding.pry
    assert_equal RLayout::BackPage, @book_cover.back_page.class
  end

  it 'should have seneca' do
    # binding.pry
    assert_equal RLayout::Seneca, @book_cover.seneca.class
  end

  it 'should have front_page' do
    # binding.pry
    assert_equal RLayout::FrontPage, @book_cover.front_page.class
  end

  it 'should have front_wing' do
    # binding.pry
    assert_equal RLayout::FrontWing, @book_cover.front_wing.class
  end


  it 'shoule save PDF' do
    assert File.exist?(@pdf_path)
    system "open #{@pdf_path}"
  end
end

__END__
describe 'create BookCover' do
  before do
    @project_path  = "/Users/mskim/test_data/book_cover"
    @pdf_path = "/Users/mskim/test_data/book_cover/cover.pdf"
    @book_cover = BookCover.new(project_path: @project_path, has_wing:true)
  end

  it 'should create BookCover' do
    assert_equal RLayout::BookCover, @book_cover.class 
  end

  it 'should have front_wing' do
    # binding.pry
    assert_equal RLayout::FrontWing, @book_cover.front_wing.class
    assert_equal 0, @book_cover.back_wing.x
  end

  it 'shoule save PDF' do
    @book_cover.save_pdf(@pdf_path, jpg:true)
    assert File.exist?(@pdf_path)
    system "open #{@pdf_path}"
  end
end