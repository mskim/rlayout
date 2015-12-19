require File.dirname(__FILE__) + '/../spec_helper'

TABLE_XML = <<-EOF
<Table AppliedTableStyle="TableStyle/Table" HeaderRowCount="1" BodyRowCount="3" ColumnCount="4">
  <Column Name="0" />
  <Column Name="1" />
  <Column Name="2" />
  <Column Name="3" />
  <Cell Name="0:0" AppliedCellStyle="CellStyle/Cell">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar &gt; TableHeader &gt; RightAlign">
      <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
        <Content>Right</Content>
      </CharacterStyleRange><Br />
    </ParagraphStyleRange>
  </Cell>
  <Cell Name="1:0" AppliedCellStyle="CellStyle/Cell">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar &gt; TableHeader &gt; LeftAlign">
      <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
        <Content>Left</Content>
      </CharacterStyleRange><Br />
    </ParagraphStyleRange>
  </Cell>
  <Cell Name="2:0" AppliedCellStyle="CellStyle/Cell">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar &gt; TableHeader &gt; CenterAlign">
      <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
        <Content>Center</Content>
      </CharacterStyleRange><Br />
    </ParagraphStyleRange>
  </Cell>
  <Cell Name="3:0" AppliedCellStyle="CellStyle/Cell">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar &gt; TableHeader">
      <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
        <Content>Default</Content>
      </CharacterStyleRange><Br />
    </ParagraphStyleRange>
  </Cell>
  <Cell Name="0:1" AppliedCellStyle="CellStyle/Cell">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar &gt; RightAlign">
      <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
        <Content>12</Content>
      </CharacterStyleRange><Br />
    </ParagraphStyleRange>
  </Cell>
  <Cell Name="1:1" AppliedCellStyle="CellStyle/Cell">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar &gt; LeftAlign">
      <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
        <Content>12</Content>
      </CharacterStyleRange><Br />
    </ParagraphStyleRange>
  </Cell>
  <Cell Name="2:1" AppliedCellStyle="CellStyle/Cell">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar &gt; CenterAlign">
      <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
        <Content>12</Content>
      </CharacterStyleRange><Br />
    </ParagraphStyleRange>
  </Cell>
  <Cell Name="3:1" AppliedCellStyle="CellStyle/Cell">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar">
      <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
        <Content>12</Content>
      </CharacterStyleRange><Br />
    </ParagraphStyleRange>
  </Cell>
  <Cell Name="0:2" AppliedCellStyle="CellStyle/Cell">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar &gt; RightAlign">
      <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
        <Content>123</Content>
      </CharacterStyleRange><Br />
    </ParagraphStyleRange>
  </Cell>
  <Cell Name="1:2" AppliedCellStyle="CellStyle/Cell">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar &gt; LeftAlign">
      <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
        <Content>123</Content>
      </CharacterStyleRange><Br />
    </ParagraphStyleRange>
  </Cell>
  <Cell Name="2:2" AppliedCellStyle="CellStyle/Cell">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar &gt; CenterAlign">
      <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
        <Content>123</Content>
      </CharacterStyleRange><Br />
    </ParagraphStyleRange>
  </Cell>
  <Cell Name="3:2" AppliedCellStyle="CellStyle/Cell">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar">
      <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
        <Content>123</Content>
      </CharacterStyleRange><Br />
    </ParagraphStyleRange>
  </Cell>
  <Cell Name="0:3" AppliedCellStyle="CellStyle/Cell">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar &gt; RightAlign">
      <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
        <Content>1</Content>
      </CharacterStyleRange><Br />
    </ParagraphStyleRange>
  </Cell>
  <Cell Name="1:3" AppliedCellStyle="CellStyle/Cell">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar &gt; LeftAlign">
      <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
        <Content>1</Content>
      </CharacterStyleRange><Br />
    </ParagraphStyleRange>
  </Cell>
  <Cell Name="2:3" AppliedCellStyle="CellStyle/Cell">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar &gt; CenterAlign">
      <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
        <Content>1</Content>
      </CharacterStyleRange><Br />
    </ParagraphStyleRange>
  </Cell>
  <Cell Name="3:3" AppliedCellStyle="CellStyle/Cell">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar">
      <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
        <Content>1</Content>
      </CharacterStyleRange><Br />
    </ParagraphStyleRange>
  </Cell>
</Table>

EOF

describe 'create table from table_xml' do
  before do
    @table_element  = REXML::Document.new(TABLE_XML)
    @table          = IdTable.new(@table_element)
    @first_cell     = @table.cells.first
  end

  it 'should create IdTable' do
    assert @table.class            == IdTable
    assert @table.header_row_count == 1
    assert @table.body_row_count   == 3
    assert @table.column_count     == 4
  end
  
  it 'should create IdTableCell' do
    assert @table.cells.first.class == IdTableCell
    assert @first_cell.cell_name    == '0:0'
    assert @first_cell.cell_paragraphs.first.class== IdParagraph
    assert @first_cell.cell_paragraphs.length    == 1
  end
end

__END__

describe 'create story from story_hash' do
  before do
    @story_hash = {
      h1: "this is h1",
      h2: "this is h2",
      h3: "this is h3",
      h4: "this is h4",
      h5: "this is h5",
      h6: "this is h6",
      p: "this is p",
    }
      xml = RLayout::IdStory.icml_from_story_hash(@story_hash)
      puts xml
  end
  it 'should create icml' do
    
    
  end
      
end

describe 'create Idml' do
  before do
    @idml_path = "/Users/mskim/Development/InDesignSDK/devtools/sdktools/idmltools/samples/helloworld/helloworld-1.idml"
    @doc = Document.new(@idml_path)
    @first_story = @doc.stories.first
    
  end
  
  it 'should create story from xml' do
    assert @first_story.class == Story
  end
  
end

