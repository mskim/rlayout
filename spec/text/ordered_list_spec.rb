require File.dirname(__FILE__) + "/../spec_helper"

describe 'create OrderedList' do
  before do
    @sample_text =<<EOF
. This is first line.
. This is the second line.
.. This is the second and level 1-1 line.
.. This is the second and level 1-2line. 
... This is the second and level 1-2-1line. 
. This is the third line. 
.. This is level 3-1 line. 
EOF
    @ol = OrderedList.new(text_block: @sample_text)    
  end
  
  # it 'should create OrderedList' do
  #   assert @ol.class == OrderedList
  # end
  
  it 'should create OrderedListItems' do
    assert @ol.graphics.first.class == OrderedListItem
    assert @ol.graphics.length      == 7
    assert @ol.graphics[1].order    == 1
    assert @ol.graphics[1].level    == 0
    assert @ol.graphics[2].order    == 0
    assert @ol.graphics[2].level    == 1
    assert @ol.graphics[4].level    == 2
    assert @ol.graphics[4].order    == 0
  end
  
  it 'should create para_strings' do
    assert  @ol.graphics[0].para_string == "1. This is first line."
    assert  @ol.graphics[2].para_string == "\ta. This is the second and level 1-1 line."
    
  end
end

describe 'create UnorderedList' do
  before do
    @sample_text =<<EOF
* This is first line.
* This is the second line.
** This is the second and level 1-1 line.
** This is the second and level 1-2line. 
*** This is the second and level 1-2-1line. 
* This is the third line. 
** This is level 3-1 line. 
EOF
    @ul = UnorderedList.new(text_block: @sample_text)    
  end
  
  it 'should create UnorderedList' do
    assert @ul.class == UnorderedList
  end
  
  it 'should create UnrrderedListItems' do
    assert @ul.graphics.first.class == UnorderedListItem
    assert @ul.graphics.length      == 7
    assert @ul.graphics[1].order    == 1
    assert @ul.graphics[1].level    == 0
    assert @ul.graphics[2].order    == 0
    assert @ul.graphics[2].level    == 1
    assert @ul.graphics[4].level    == 2
    assert @ul.graphics[4].order    == 0
  end
  # 
  # it 'should create para_strings' do
  #   assert  @ol.graphics[0].para_string == "1. This is first line."
  #   assert  @ol.graphics[2].para_string == "\ta. This is the second and level 1-1 line."
  #   
  # end
end


