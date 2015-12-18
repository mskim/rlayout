require File.dirname(__FILE__) + '/../spec_helper'

describe 'create story ' do
  before do
    @idml_path = "/Users/mskim/Development/InDesignSDK/devtools/sdktools/idmltools/samples/helloworld/helloworld-1.idml"
    @doc  = IdDocument.new(@idml_path)
    @ms   = @doc.master_spreads.first
    puts @ms.spread_attributes
    puts "@ms.pages.length:#{@ms.pages.length}"
  end
  
  it 'should get paragraph_styles' do
    assert @doc.master_spreads.class    == Array
    assert @doc.master_spreads.first.class    == MasterSpread
  end
end