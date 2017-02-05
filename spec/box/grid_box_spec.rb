require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

# describe 'save GridBox sample' do
#   before do
#     @pdf_path = "/Users/Shared/rlayout/output/grid_box_sample.pdf"
#   end
#
#   it 'should save pdf' do
#   end
#
#   it 'should save sample grid_box' do
#     @pdf_path = "/Users/Shared/rlayout/output/grid_box_sample.pdf"
#     script = <<-EOF
#       @output_path = "#{@pdf_path}"
#       @items = []
#       20.times do
#         @items << RLayout::Image.new(fill_color: "red")
#       end
#       RLayout::GridBox.new(width:500, height:600).layout_items(@items)
#     EOF
#     system "echo '#{script}' | /Applications/rjob.app/Contents/MacOS/rjob"
#     assert File.exist?(@pdf_path) == true
#   end
#
#   it 'should save sample grid_box' do
#     @pdf_path = "/Users/Shared/rlayout/output/grid_box_sample2.pdf"
#     script = <<-EOF
#       @output_path = "#{@pdf_path}"
#       @items = []
#       20.times do
#         @items << RLayout::Image.new(image_path: "some_path", fill_color: "green")
#       end
#       RLayout::GridBox.new(width:500, height:600).layout_items(@items)
#     EOF
#     system "echo '#{script}' | /Applications/rjob.app/Contents/MacOS/rjob"
#     assert File.exist?(@pdf_path) == true
#   end
# end

describe 'layout_items with given grid_base' do
  before do
    @gb = GridBox.new(grid_base: [3,4], width:500, height:600)
    items = []
    20.times do
      items << Image.new(nil)
    end
    @gb.layout_items(items)
  end

  it 'should create grid_rows' do
    assert @gb.grid_base[0] == 4
    assert @gb.grid_base[1] == 5
  end
end

describe 'layout_items with given grid_column' do
  before do
    @gb = GridBox.new(given_grid_column: 3, width:500, height:600)
    items = []
    20.times do
      items << Image.new(nil)
    end
    @gb.layout_items(items)
  end

  it 'should create grid_rows' do
    assert @gb.grid_base[1] == 5
    assert @gb.grid_base[0] == 4
  end
end

describe 'layout_items with no grid_base' do
  before do
    @gb = GridBox.new(width:500, height:600)
    items = []
    20.times do
      items << Image.new()
    end
    @gb.layout_items(items)
  end
  it 'should create grid_cells' do
    assert @gb.grid_cells.length == 20
  end

end

describe 'GridBox' do
  before do
    @gb = GridBox.new()
  end

  it 'shuld create GridBox' do
    assert @gb.class == GridBox
  end

  it 'shuld have nil grid_base' do
    assert @gb.grid_base.nil? == true
  end

end
