require 'minitest/autorun'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '../..', 'lib')
require 'rlayout/graphic'
require 'rlayout/container'
include RLayout

describe 'testing container creation' do
  before do
    # @container = Container.new(:width=>600, :height=>800, :layout_space=>20, :layout_direction=>"horizontal") do
    @container = Container.new(:margin=>10, :width=>600, :height=>800, :layout_space=>0, :layout_direction=>"vertical", :top_margin=>0, :bottom_margin=>10) do
      rect(:fill_color=>"red", :layout_length=>3)
      rect(:fill_color=>"blue")
      circle(:fill_color=>"green")
      circle(:fill_color=>"green")
      relayout!
    end
    @svg_path = "/Users/Shared/rlayout/output/auto_layout_test2.svg"
  end
  
  it 'should save svg' do
    @container.save_svg(@svg_path)
    File.exists?(@svg_path).must_equal true
    # system "open #{@svg_path}"
  end
end


describe 'testing container creation' do
  before do
    # @container = Container.new(:width=>600, :height=>800, :layout_space=>20, :layout_direction=>"horizontal") do
    @container = Container.new(:margin=>10, :width=>600, :height=>800, :layout_space=>0, :layout_direction=>"vertical", :top_margin=>0, :bottom_margin=>10) do
      container :line_color =>'black', :margin=>10, :line_width =>2, :line_type =>0, :layout_direction=>"horizontal", :layout_space=>5  do
        container(:fill_color=>"yellow", :layout_length =>2) do
          rect(:fill_color=>"orange", :width=>30, :layout_expand=>[:height])
          # text(:fill_color=>"green", :text_string =>"This is a string")
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
    @svg_path = "/Users/Shared/rlayout/output/auto_layout_test.svg"
  end
  
  it 'should save svg' do
    @container.save_svg(@svg_path)
    File.exists?(@svg_path).must_equal true
    # system "open #{@svg_path}"
  end
    
  it 'should create container' do
    @container.must_be_kind_of Container
    @container.graphics.length.must_equal 5
    @container.graphics[0].must_be_kind_of Container
  end
  
end

# describe 'has_expanding_child' do
#   before do
#     @con = Container.new(width: 400, height:600) do
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
    # @con = Container.new(width: 400, height:600, fill_color: 'yellow', layout_align:'top') do
    # @con = Container.new(width: 400, height:600, fill_color: 'yellow', layout_align:'bottom') do
    # @con = Container.new(width: 400, height:600, fill_color: 'yellow', layout_align:'center') do
    @con = Container.new(width: 400, height:600, layout_align:'center') do
      rect(:fill_color=>"orange")
      rect(:fill_color=>"red")
      text(:fill_color=>"green", :text_string =>"This is a string")
      circle(:fill_color=>"gray", :layout_expand=>[:width])
      rect(:fill_color=>"orange", :layout_expand=>[:width])
      text(:fill_color=>"red", :text_string =>"This is a string", :layout_expand=>[:width])
      circle(:fill_color=>"gray", :layout_expand=>[:width])
    end    
    @con.relayout!
  end
    
  it 'should save svg' do
    @svg_path = "/Users/Shared/rlayout/output/auto_layout_relayout_test.svg"
    @con.save_svg(@svg_path)
    # system("open #{@svg_path}")
  end
  
  # it 'should save yml' do
  #   @yml_path = "/Users/Shared/rlayout/output/auto_layout_relayout_test.yml"
  #   @con.save_yml(@yml_path)
  #   system("open #{@yml_path}")
  # end
end

