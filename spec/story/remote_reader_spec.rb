require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create Reader with sample story file' do
  
  it 'shold create story' do
    @reader  = RemoteReader.new(sample_text)
    assert @reader.class == Reader
  end
end

