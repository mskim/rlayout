require File.dirname(__FILE__) + "/../spec_helper"

describe 'save style heading' do
  before do
    @path         = "/Users/mskim/Development/hwp/section_test1.hml"
    @output_path  = "/Users/mskim/Development/hwp/section_test1" 
        
    @path         = "/Users/mskim/Development/hwp/image_test1.hml"
    @output_path  = "/Users/mskim/Development/hwp/image_test1" 
    @style_path   = "/Users/mskim/Development/hwp/image_test1/style.yml"
    @tables_path  = "/Users/mskim/Development/hwp/image_test1/tables" 
    @images_path  = "/Users/mskim/Development/hwp/image_test1/images" 
    
    @path         = "/Users/mskim/Development/hwp/ms.hml"
    @style_path   = "/Users/mskim/Development/hwp/ms/style.yml"
    @output_path  = "/Users/mskim/Development/hwp/ms" 
    @tables_path  = "/Users/mskim/Development/hwp/ms/tables" 
    
    @path         = "/Users/mskim/Development/hwp/section_test1.hml"
    @output_path  = "/Users/mskim/Development/hwp/section_test1" 
    
    @hwp  = Hwpml.new(@path)
  end
  
  it "should save style heading" do
    @hwp.save
    assert File.directory?(@output_path) == true
    # assert File.directory?(@tables_path) == true
    # assert File.directory?(@images_path) == true
  end
  
end

__END__
describe 'create hwpml' do
  before do
    @path = "/Users/mskim/Development/hwp/section_test.hml"
    @path = "/Users/mskim/Development/hwp/section_test1.hml"
    @path = "/Users/mskim/Development/hwp/ms.hml"
    @hwp  = Hwpml.new(path: @path)
  end
  
  it 'should crete Hwpml' do
    assert @hwp.class == Hwpml
  end
  
  it 'should crete char_styles' do
    assert @hwp.char_styles.first.class == Hash
  end
  
  it 'should crete para_styles' do
    assert @hwp.para_styles.first.class == Hash
  end
  
  it 'should crete styles' do
    assert @hwp.styles.first.class == Hash
  end
  
end

