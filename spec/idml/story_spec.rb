require File.dirname(__FILE__) + '/../spec_helper'

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

__END__
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

