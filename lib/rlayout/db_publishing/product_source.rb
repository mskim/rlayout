
# Variabble Printing Strategy
# 1. Have a Rails Database App for mamaging items
# 2. Generate PDF Cells for each item with template, 
#    we need to consider width to height ratio of final book column.
# 3. Finally Layout pdf cells into a book

# PRODUCT_BOX_TEMPLATE = Container.new(nil) do
#   container do
#     image(tag: "product_image")
#     container do
#       text(tag: "name")
#       text(tag: "title")
#       text(tag: "cell")
#     end
#   end
#   text(tag: "address1")
#   text(tag: "address2")
# end

module RLayout
  class ProudctBox < Container
    attr_accessor :category, :name, :proudct_id, :price, :description, :image_path
    attr_accessor :template, :product_box
    def initialize(parent_graphic, options={}, &block)
      super
      @klass = "ProductBox"
      @template = options[:template]
      @company  = options[:company]
      @phone  = options[:phone]
      @coyp1  = options[:coyp1]
      @coyp2  = options[:coyp2]
      @image_path  = options[:image_path]
      layout_item
      self
    end
    
    def layout_item
      
    end
    
    def self.from_template(template, options={})
      product_box = Container.new(nil, template)
      product_box.substibute_variables(options)
      product_box
    end
    
    def self.samples_of(number)
      ad = []
      number.times do
        ad << self.sample
      end
      ad
    end
    
    def self.sample
      proudct = ProductBox.new(nil, line_width: 2, line_color: 'gray') do
        @company = text(text_string: ramdom_text, fill_color: random_color, line_with: 2, line_color: 'red')
        @phone   = text(text_string: ramdom_text, fill_color: random_color)
        @copy1   = text(text_string: ramdom_text, fill_color: random_color, line_with: 2, line_color: 'red')
        @copy2   = text(text_string: ramdom_text, fill_color: random_color, line_with: 2, line_color: 'red')
      end
      proudct.relayout!
      proudct
    end
    
    def layout_text
      
    end
    
    def layout_text(room)
      
    end
    
    def is_breakable?
      false
    end
  end
  
end

