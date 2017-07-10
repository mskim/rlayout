require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create LeaderRow' do
  before do
    row_text = "Noodle, 19.00"
    @lr = LeaderRow.new(width: 400, height: 18, row_text: row_text)
  end

  it 'should create LeaderRow' do
    assert @lr.graphics.length == 3
    assert @lr.graphics.first.class == LeaderCell
    assert @lr.graphics[1].class == LeaderCell
    assert @lr.graphics[2].class == LeaderCell
  end

  it 'should have cells with adjusted height' do
    first_cell = @lr.graphics.first
    assert first_cell.height < 18
  end

  it 'should have cells with adjusted x-position' do
    assert @lr.graphics[0].x == 0
    assert @lr.graphics[1].x == 100
    assert @lr.graphics[2].x == 300
  end
end


__END__
describe 'create page with menu' do
  before do
    @page = RLayout::Page.new(nil) do
      text("Menu Sample", fill_color: "yellow", font_size: 16)
      m = Menu.new(parent: self, menu_text_path: "/Users/mskim/menu/menu_text.csv", layout_length: 7)
      relayout!
    end
  end

  it 'should create table' do
    assert @page.graphics.first.class == Text
    assert @page.graphics[1].class == Menu
    puts "@page.graphics[1].graphics.length:#{@page.graphics[1].graphics.length}"
  end
end
