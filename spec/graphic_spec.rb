require File.dirname(__FILE__) + "/spec_helper"

describe 'graphic text test' do
  before do
    @t = Text.new(nil, :text_string=>"this is text", :width =>300)
    @pdf_path = File.dirname(__FILE__) + "/output/graphic_text_test.pdf"
    @svg_path = File.dirname(__FILE__) + "/output/graphic_text_test.svg"
  end
  
  it 'should save random grapics' do    
    @t.save_svg(@svg_path)
    @t.save_pdf(@pdf_path)
  end
end

describe 'save pdf random' do
  before do
    @g = Graphic.random_graphics(200)
    @path = File.dirname(__FILE__) + "/output/graphic_random_test.pdf"
  end
  
  it 'should create Graphic' do
    @g.must_be_kind_of Array
  end
  
  it 'should save random grapics' do    
    p = Page.new(nil)
    p.add_graphics(@g)
    p.save_pdf(@path)
  end
end




describe 'save pdf' do
  before do
    @g = Graphic.new(nil, :fill_color=>"red", :line_width=>5, :line_color=>"black")
    @path = File.dirname(__FILE__) + "/output/graphic_pdf_test.pdf"
  end
  
  it 'should save pdf' do
    @g.save_pdf(path)
    File.exists?(@path).must_equal true
  end
end

describe 'Graphic.random(number) ' do
  before do
    @g = Graphic.random_graphics(100)
    @path = File.dirname(__FILE__) + "/output/graphic_random_test.svg"
  end
  
  it 'should create Graphic' do
    @g.must_be_kind_of Array
  end
  
  it 'should save random grapics' do    
    p = Page.new(nil)
    p.add_graphics(@g)
    p.save_svg(@path)
  end
end
describe "graphic" do
  before do
    @graphic = Graphic.new(nil)
  end
  
  it 'should create graphic ' do
    @graphic.must_be_kind_of Graphic
  end
  
  it 'should have default values' do
    @graphic.x.must_equal 0
    @graphic.y.must_equal 0
    @graphic.width.must_equal 100
    @graphic.height.must_equal 100
    
    @graphic.fill_type.must_equal nil
    @graphic.fill_color.must_equal nil
    @graphic.fill_other_color.must_equal nil    
    @graphic.line_color.must_equal nil
    @graphic.line_width.must_equal nil
    @graphic.line_dash.must_equal nil
    
    @graphic.unit_length.must_equal 1
    @graphic.grid_x.must_equal 0
    @graphic.grid_y.must_equal 0
    @graphic.grid_width.must_equal 1
    @graphic.grid_height.must_equal 1
    @graphic.layout_expand.must_equal [:width,:height]
  end
  
  it 'init should match hash values' do
    @graphic.to_hash.must_equal Hash.new
  end
end

describe 'graphic svg' do
  before do
    @graphic = Graphic.new(nil, :line_width=>5)
  end
  
  it 'should create svg' do
    @graphic.to_svg.must_be_kind_of String
#     @graphic.to_svg.must_equal <<EOF
#     "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">
#     <rect x=\"0\" y=\"0\" width=\"100\" height=\"100\" stroke=\"black\" stroke-width=\"5\"></rect>
#     </svg>"
# EOF
  end
end

describe 'test getters and setter' do
  before do
    @graphic = Graphic.new(nil) do
      line_width=10
    end
  end
  
  it 'should set instance variable value' do
    @graphic.line_width.must_equal 10
  end
  
end

describe 'ancestry test' do
  before do
    @page = Page.new(nil)
    @nested = Container.new(@page)
      
  end
  
  it 'should create tree' do
    @page.graphics.length.must_equal 1
    puts @nested.to_mongo
  end
end