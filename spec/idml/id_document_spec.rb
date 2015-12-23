require File.dirname(__FILE__) + '/../spec_helper'

describe 'create idyml from idml' do
  before do
    @idml_path = "/Users/mskim/Development/idml/samples/helloworld/helloworld-1.idml"
    @doc = IdDocument.new(@idml_path)
    @idyml = @doc.to_id_layout
    @id_layout_path = "/Users/mskim/Development/idml/samples/helloworld/helloworld-1.id_layout"
  end
  
  it 'should convert idml to idyml' do
    assert File.directory?(@id_layout_path)
  end
    
end

__END__

describe 'create story ' do
  before do
    @idml_path = "/Users/mskim/Development/InDesignSDK/devtools/sdktools/idmltools/samples/helloworld/helloworld-1.idml"
    @doc = IdDocument.new(@idml_path)
  end
  
  it 'should create Document class' do
    assert @doc.stories.class   == Array
  end
  
  # it 'should create Document class' do
  #   assert @doc.class             == IdDocument
  #   assert @doc.spreads.length    == 1
  #   assert @doc.fonts.class       == Fonts
  #   assert @doc.graphic_pkg.class == GraphicPkg
  #   assert @doc.styles.class      == Styles
  #   assert @doc.tags.class        == Tags
  #   assert @doc.tags.class        == Tags
  #   assert @doc.master_spreads.class == Array
  #   assert @doc.spreads.class     == Array
  #   assert @doc.stories.class     == Array
  #   assert @doc.backing_story.class == BackingStory
  # end
end

__END__


