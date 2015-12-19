require File.dirname(__FILE__) + '/../spec_helper'

describe 'create story ' do
  before do
    @idml_path  = "/Users/mskim/Development/InDesignSDK/devtools/sdktools/idmltools/samples/helloworld/helloworld-1.idml"
    @doc        = IdDocument.new(@idml_path)
    @spread     = @doc.spreads.first
    @pages      = @spread.pages
    @text_frames = @spread.text_frames
  end
  
  it 'should get spread class' do
    assert @doc.spreads.class         == Array
    assert @pages.length              == 1
    assert @text_frames.length        == 1
  end
end