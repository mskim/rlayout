require File.dirname(__FILE__) + "/spec_helper"

describe 'save jpg' do
  before do
    @g        = Graphic.new(nil, fill_color: 'red')
    @jpg_path = File.dirname(__FILE__) + "/output/graphic_jpg_test.jpg"
  end
  
  it 'should save jpg' do
    @g.save_jpg(@jpg_path)
    File.exists?(@jpg_path).must_equal true
    system("open #{@jpg_path}")
  end
  
  it 'should save pdf with jpg options' do
    @g        = Graphic.new(nil, fill_color: 'blue')
    
    @pdf_path = File.dirname(__FILE__) + "/output/graphic_pdf_n_jpg_test.pdf"
    @jpg_path = File.dirname(__FILE__) + "/output/graphic_pdf_n_jpg_test.jpg"
    @g.save_pdf(@pdf_path, jpg: true)
    File.exists?(@pdf_path).must_equal true
    File.exists?(@jpg_path).must_equal true
    system("open #{@pdf_path}")
    system("open #{@jpg_path}")
  end
  
end
__END__

describe 'rect intersect' do
  it 'should not intersect' do
    r1 = [0, 0, 379.693333333333, 105.0]
    r2 = [0, 120, 184.846666666666, 8]
    puts "y intersect:#{intersects_y(r1,r2)}"
    puts "x intersect:#{intersects_x(r1,r2)}"
    puts "all intersects:#{intersects_rect(r1,r2)}"
    intersects_rect(r1,r2).must_equal false
  end
  
end


describe ' Graphic from Hash ' do
  before do
    h = {
      :klass => "Container",
      :fill_color=> 'red',
      :graphics => [
        {:klass => "Rectangle", :fill_color=> 'blue'},
        {:klass => "Rectangle", :fill_color=> 'green'},
        ]
    }
    @t = Container.new(nil, h)
  end
    
  it 'should save Rectangle from hash' do
    @pdf_path = File.dirname(__FILE__) + "/output/graphic_from_hash.pdf"
    @t.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
    system("open #{@pdf_path}")
  end
end

describe 'testing Text ' do
  before do
    @t = Text.new(nil, width: 400,  text_string: "This is text string and I like it very much. Wouldn't you? "*4, text_size: 24, text_alignment: 'right')
  end
  
  it 'should create heading' do
    @t.must_be_kind_of Text
    @t.text_size.must_equal 24
  end
  
  it 'should save Text' do
    @svg_path = File.dirname(__FILE__) + "/output/text_test.svg"
    @pdf_path = File.dirname(__FILE__) + "/output/texxt_test.pdf"
    # @t.save_svg(@svg_path)
    # File.exists?(@svg_path).must_equal true
    @t.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
  end
  
end

# describe 'graphic text test' do
#   before do
#     @t = Text.new(nil, :text_string=>"this is text at last.", :width =>300)
#     @pdf_path = File.dirname(__FILE__) + "/output/graphic_text_test.pdf"
#     @svg_path = File.dirname(__FILE__) + "/output/graphic_text_test.svg"
#   end
#   
#   it 'should save random grapics' do    
#     @t.save_svg(@svg_path)
#     @t.save_pdf(@pdf_path)
#   end
# end

__END__
describe 'graphic fill test' do
  before do
    @g = Graphic.new(nil, fill_color: 'red', line_width: 5, line_color: 'yellow')
    @pdf_path = File.dirname(__FILE__) + "/output/graphic_fill_test.pdf"
  end
  
  it 'shuold save graphic' do
    @g.save_pdf(@pdf_path)
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

# describe 'save pdf' do
#   before do
#     @g = Graphic.new(nil, :fill_color=>"red", :line_width=>5, :line_color=>"black")
#     @path = File.dirname(__FILE__) + "/output/graphic_pdf_test.pdf"
#   end
#   
#   it 'should save pdf' do
#     @g.save_pdf(@path)
#     File.exists?(@path).must_equal true
#   end
# end
# 
# describe 'Graphic.random(number) ' do
#   before do
#     @g = Graphic.random_graphics(100)
#     @path = File.dirname(__FILE__) + "/output/graphic_random_test.svg"
#   end
#   
#   it 'should create Graphic' do
#     @g.must_be_kind_of Array
#   end
#   
#   it 'should save random grapics' do    
#     p = Page.new(nil)
#     p.add_graphics(@g)
#     p.save_svg(@path)
#   end
# end
# describe "graphic" do
#   before do
#     @graphic = Graphic.new(nil)
#   end
#   
#   it 'should create graphic ' do
#     @graphic.must_be_kind_of Graphic
#   end
#   
#   it 'should have default values' do
#     @graphic.x.must_equal 0
#     @graphic.y.must_equal 0
#     @graphic.width.must_equal 100
#     @graphic.height.must_equal 100
#     
#     @graphic.fill_type.must_equal nil
#     @graphic.fill_color.must_equal nil
#     @graphic.fill_other_color.must_equal nil    
#     @graphic.line_color.must_equal nil
#     @graphic.line_width.must_equal nil
#     @graphic.line_dash.must_equal nil
#     
#     @graphic.layout_length.must_equal 1
#     @graphic.grid_rect[0].must_equal 0
#     @graphic.grid_rect[1].must_equal 0
#     @graphic.grid_rect[2].must_equal 1
#     @graphic.grid_rect[3].must_equal 1
#     @graphic.layout_expand.must_equal [:width,:height]
#   end
#   
#   it 'init should match hash values' do
#     @graphic.to_hash.must_equal Hash.new
#   end
# end
# 
# describe 'graphic svg' do
#   before do
#     @graphic = Graphic.new(nil, :line_width=>5)
#   end
#   
#   it 'should create svg' do
#     @graphic.to_svg.must_be_kind_of String
# #     @graphic.to_svg.must_equal <<EOF
# #     "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">
# #     <rect x=\"0\" y=\"0\" width=\"100\" height=\"100\" stroke=\"black\" stroke-width=\"5\"></rect>
# #     </svg>"
# # EOF
#   end
# end
# 
# describe 'ancestry test' do
#   before do
#     @page = Page.new(nil)
#     @nested = Container.new(@page)
#       
#   end
#   
#   it 'should create tree' do
#     @page.graphics.length.must_equal 1
#     @nested.to_mongo
#   end
# end
# 
