require File.dirname(__FILE__) + '/../spec_helper'

describe 'create story ' do
  before do
    @idml_path = "/Users/mskim/Development/InDesignSDK/devtools/sdktools/idmltools/samples/helloworld/helloworld-1.idml"
    @doc = IdDocument.new(@idml_path)
    @doc.paragraph_styles
  end
  
  it 'should get paragraph_styles' do
    assert @doc.paragraph_styles.class    == Array
    assert @doc.paragraph_styles.first[:text_font]    == 'Times New Roman'
    assert @doc.paragraph_styles.first[:name]    == 'No paragraph style'
    assert @doc.paragraph_styles[1][:based_on]    == 'No paragraph style'
  end
end