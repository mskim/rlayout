require 'minitest/autorun'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '../..', 'lib')
require 'rlayout/graphic'
require 'rlayout/container'
include RLayout

describe 'pgscritp for Container ' do
  before do
    @container = RLayout::Container.new() do
      rect(fill_color: "red")
      rect(fill_color: "blue")
      relayout!
    end
  end
  
  it 'should have two graphics' do
    @container.graphics.length.must_equal 2
  end
end

describe 'processing from raw text ' do
  before do
    @text = <<-EOF.gsub(/^\s*/, "")
        Container.new(:width=>600, :height=>800) do
          split_v(3, :fill_color=>"blue", :layout_space=>10)
          @graphics.first.fill.color = 'white'
          @graphics.first.split_h(3, :fill_color=>'red', :layout_space=>10)
        end
    EOF
    @container = eval(@text)
  end
  
  it 'should create container' do
    @container.must_be_kind_of Container
  end
  
  it 'should have two graphics' do
    @container.graphics.length.must_equal 3
  end
  
  it 'should have layout_direction' do
    @container.layout_direction.must_equal 'vertical'
  end
  
  it 'should apply option values' do
    @container.graphics.first.fill.color.must_equal 'white'
    @container.graphics.first.height.must_equal 260
    @container.graphics[1].fill.color.must_equal 'blue'
  end
end

describe 'testing container split-v' do
  before do
    @container = Container.new(:width=>600, :height=>800) do
      split_v(3, :fill_color=>"blue", :layout_space=>10)
      @graphics.first.fill.color = 'white'
      @graphics.first.split_h(3, :fill_color=>'red', :layout_space=>10)
    end
  end
  
  it 'should create container' do
    @container.must_be_kind_of Container
  end
  
  it 'should have two graphics' do
    @container.graphics.length.must_equal 3
  end
  
  it 'should have layout_direction' do
    @container.layout_direction.must_equal 'vertical'
  end
  
  it 'should apply option values' do
    @container.graphics.first.fill.color.must_equal 'white'
    # @container.graphics.first.height.must_equal 26
    # @container.graphics[1].height.must_equal 26
    # @container.graphics[1].fill_color.must_equal 'white'
  end
  
  it 'should save' do
    @svg_path = "/Users/Shared/rlayout/output/container_pgscript_split-v.svg"
    @container.save_svg(@svg_path)
    File.exist?(@svg_path)
  end
end

describe 'testing container split-h' do
  before do
    @container = Container.new() do
      split_h(3, :fill_color=>"gray", :layout_space=>10)
    end
  end
  
  it 'should create container' do
    @container.must_be_kind_of Container
  end
  
  it 'should have two graphics' do
    @container.graphics.length.must_equal 3
  end
  
  it 'should have layout_direction' do
    @container.layout_direction.must_equal 'horizontal'
  end
  
  it 'should save' do
    svg_path = "/Users/Shared/rlayout/output/container_pgscript_split-h.svg"
    @container.save_svg(svg_path)
  end
end

