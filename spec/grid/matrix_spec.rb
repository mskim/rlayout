require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe ' create Matrix' do
  before do
    @pdf_path       = "#{ENV["HOME"]}/test_data/matrix/matrix_image.pdf"
    @image_folder   = "#{ENV["HOME"]}/test_data/images"
    @m = Matrix.new(width:400, height: 400, image_folder: @image_folder)
  end

  it 'should create Matrix' do
    assert_equal Matrix, @m.class
    assert_equal 400, @m.width
    assert_equal 400, @m.height
  end

  it 'should create cells' do
    @first_cell = @m.graphics.first
    @last_cell = @m.graphics.last
    assert_equal 4, @m.graphics.length
    assert_equal MatrixImageCell, @first_cell.class
    assert_equal 1, @first_cell.cell_position
    assert_equal 0, @first_cell.x
    assert_equal 0, @first_cell.y
    assert 200 < @last_cell.x
  end

  it 'should save matrix' do
    @m.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
  end
end

require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe ' create Matrix' do
  before do
    @pdf_path       = "#{ENV["HOME"]}/test_data/matrix/matrix_image2.pdf"
    @image_folder   = "#{ENV["HOME"]}/test_data/images"
    @m = Matrix.new(column: 4, row: 1, width:600, height: 150, image_folder: @image_folder)
  end

  it 'should save matrix' do
    @m.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
  end
end

describe ' create Matrix with TextCell' do
  before do
    @pdf_path = "#{ENV["HOME"]}/test_data/matrix/matrix_text.pdf"
    @m = Matrix.new(width:400, height: 400, cell_type: 'text')
  end

  it 'should create Matrix' do
    assert_equal Matrix, @m.class
  end

  it 'should create cells' do
    @last_cell = @m.graphics.last
    assert_equal 4, @m.graphics.length
    assert_equal MatrixTextCell, @last_cell.class
    assert_equal 4, @m.graphics.last.cell_position
    assert 200 < @last_cell.x
    assert 200 < @last_cell.y
    assert 200 > @last_cell.width
    assert 200 > @last_cell.width
  end

  it 'should save matrix' do
    @m.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
  end
end
