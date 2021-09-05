
# ItemBox
# ItemBox is a Paragraph with image.
# ItemBox works similar to Paragraph.
# It is responsible for laying out items into columns.

# markdown format
# ![item_title](path_to_image)
# item_description

# example
# !["디자인 코딩"](images/1.jpg)
# 디자인 코팅은 디자인너들이 일러스트레이터를 대신 해서 반목적으로 사용하는 디자인 패턴을 만들수 있는 방식에 대한 책이다.

module RLayout
  attr_reader :kind, :image_path, :image_position, :image_box, 
  attr_reader :title, :body
  
  class ItemBox < Container

    def initialize(options={})
      super
      @kind = options[:kind] || 'divided'   # dropped
      @image_path = options[:image_path] 
      @image_position = 'left'
      @items = options[:items]

      self
    end
  end
end