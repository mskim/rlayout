require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create TOCChapter' do
  before do
    path = "/Users/Shared/SoftwareLab/document_template/toc"
    @tt = TOCChapter.new(project_path: path)
    @document=@tt.document
    @page     = @document.pages.first
    @toc_table = @page.graphics.last
    @toc_last_row = @page.graphics.last.graphics.last
  end
    
  it 'should create TocTable' do
    assert @tt.class == TOCChapter
    assert @toc_table.graphics.length == 13
    assert @toc_table.graphics.last.class == TocTableRow
    assert @toc_last_row.graphics.length == 3
  end
end

__END__
describe 'create TocTableRow' do
  before do
    markup   = "h3"
    para_string = "01.Chapter\t12"
    para = {markup: markup, para_string: para_string}
    options = {width: 400, height: 18, para: para}
    @lr = TocTableRow.new(options)
    puts "@lr.graphics.first.class:#{@lr.graphics.first.class}"
    puts "@lr.graphics[0].width:#{@lr.graphics[0].width}"
    puts "@lr.graphics[1].width:#{@lr.graphics[1].width}"
    puts "@lr.graphics[2].width:#{@lr.graphics[2].width}"
  end
    
  it 'should create TocRow' do
    assert @lr.graphics.length == 3
    assert @lr.graphics.first.class == TocTextCell
     assert @lr.graphics.first.width == 114
     assert @lr.graphics[1].class == LeaderToken
     assert @lr.graphics[1].width == 228
     assert @lr.graphics[2].class == TocTextCell
    #  assert @lr.graphics[12.width == 57
     
  end
end


__END__
describe 'create page with menu' do
  before do
    @page = RLayout::Page.new(nil) do
      text("Menu Sample", fill_color: "yellow", text_size: 16)
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
