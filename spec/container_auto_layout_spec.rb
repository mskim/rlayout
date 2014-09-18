require File.dirname(__FILE__) + "/spec_helper"

describe 'testing container creation' do
  before do
    # @container = Container.new(nil, :width=>600, :height=>800, :layout_space=>20, :layout_direction=>"horizontal") do
    @container = Container.new(nil, :width=>600, :height=>800, :layout_space=>20, :layout_direction=>"vertical", :top_margin=>20, :bottom_margin=>20) do
      rect(:fill_color=>"red", :unit_length=>3)
      rect(:fill_color=>"blue")
      circle(:fill_color=>"green")
      circle(:fill_color=>"green")
      
      relayout!
    end
    @path = File.dirname(__FILE__) + "/output/container_test.svg"
    @pdf_path = File.dirname(__FILE__) + "/output/container_test.pdf"
  end
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  it 'should save' do
    @container.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
    system("open #{@pdf_path}") if File.exists?(@pdf_path)
    
  end
  
  # it 'should create container' do
  #   @container.must_be_kind_of Container
  #   @container.graphics.length.must_equal 3
  #   @container.graphics[0].must_be_kind_of Rectangle
  # end
  
end
