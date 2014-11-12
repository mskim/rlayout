require File.dirname(__FILE__) + "/../spec_helper"

# describe 'has_expanding_child' do
#   before do
#     @con = Container.new(nil, width: 400, height:600) do
#       rect(:fill_color=>"orange", :width=>30, :layout_expand=>[:height])
#       text(:fill_color=>"green", :text_string =>"This is a string")
#       circle(:fill_color=>"gray")
#     end    
#   end
#   
#   it 'it should have expanding child' do
#     @con.has_expanding_child?.must_equal true
#   end
# end

describe 'has_expanding_child no' do
  before do
    # @con = Container.new(nil, width: 400, height:600, fill_color: 'yellow', layout_align:'top') do
    # @con = Container.new(nil, width: 400, height:600, fill_color: 'yellow', layout_align:'bottom') do
    # @con = Container.new(nil, width: 400, height:600, fill_color: 'yellow', layout_align:'center') do
    @con = Container.new(nil, width: 400, height:600, fill_color: 'yellow', layout_align:'justified') do
      # rect(:fill_color=>"orange", :width=>30, :layout_expand=>[:width])
      # text(:fill_color=>"green", :text_string =>"This is a string", :layout_expand=>[:width])
      circle(:fill_color=>"gray", :layout_expand=>[:width], :layout_expand=>[:width])
      rect(:fill_color=>"orange", :width=>30, :layout_expand=>[:width])
      text(:fill_color=>"green", :text_string =>"This is a string", :layout_expand=>[:width])
      circle(:fill_color=>"gray", :layout_expand=>[:width])
    end    
    @con.relayout!
  end
    
  it 'should save pdf' do
    @pdf_path = File.dirname(__FILE__) + "/../output/auto_layout_relayout_test.pdf"
    @con.save_pdf(@pdf_path)
    system("open #{@pdf_path}")
  end
end


__END__
describe 'testing container creation' do
  before do
    # @container = Container.new(nil, :width=>600, :height=>800, :layout_space=>20, :layout_direction=>"horizontal") do
    @container = Container.new(nil, :margin=>10, :width=>600, :height=>800, :layout_space=>20, :layout_direction=>"vertical", :top_margin=>0, :bottom_margin=>10) do
      container :line_color =>'black', :margin=>10, :line_width =>2, :line_type =>0,:line_color =>'red', :layout_direction=>"horizontal", :layout_space=>5  do
        container(:fill_color=>"yellow", :layout_length =>2) do
          rect(:fill_color=>"orange", :width=>30, :layout_expand=>[:height])
          text(:fill_color=>"green", :text_string =>"This is a string")
          circle(:fill_color=>"gray")
        end
        circle(:fill_color=>"orange")
        circle(:fill_color=>"blue")
        circle(:fill_color=>"gray")
      end
      rect(:fill_color=>"red", :layout_length=>3)
      rect(:fill_color=>"blue")
      circle(:fill_color=>"green")
      circle(:fill_color=>"green")
      relayout!
    end
    @pdf_path = File.dirname(__FILE__) + "/../output/auto_layout_test.pdf"
  end
  
  it 'should save pdf' do
    @container.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
  end
  
  it 'should save' do
    @container.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
    # system("open #{@pdf_path}") if File.exists?(@pdf_path)
    
  end
  
  it 'should create container' do
    @container.must_be_kind_of Container
    @container.graphics.length.must_equal 5
    @container.graphics[0].must_be_kind_of Container
  end
  
end
