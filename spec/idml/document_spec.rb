require File.dirname(__FILE__) + '/../spec_helper'

describe 'create story ' do
  before do
    @idml_path = "/Users/mskim/Development/InDesignSDK/devtools/sdktools/idmltools/samples/helloworld/helloworld-1.idml"
    @doc = IdDocument.new(@idml_path)
  end
  
  it 'should create Document class' do
    assert @doc.stories.class   == Array
  end
  
  it 'should create Document class' do
    assert @doc.class           == Document
    assert @doc.spreads.length  == 1
    assert @doc.fonts.class     == Fonts
    assert @doc.graphic.class   == Graphic
    assert @doc.styles.class    == Styles
    assert @doc.tags.class      == Tags
    assert @doc.tags.class      == Tags
    assert @doc.master_spreads.class == Array
    assert @doc.spreads.class   == Array
    assert @doc.stories.class   == Array
    assert @doc.backing_story.class   == BackingStory
  end
end

