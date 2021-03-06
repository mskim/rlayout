
# HeadingContainer is a variation of Heading.
# HeadingContainer is used for creating non-stacking complex Headings, 
# a complex free form Headings, Newspaper, Study Book, Magazine, Catalog
# Template is created with tags and replace by content with set_content
#
module RLayout

	class HeadingContainer < Container
	  attr_accessor :tag_list
	  def initialize(options={}, &block)
	    options[:layout_expand] = :width unless options[:layout_expand]
      super
      if block
        instance_eval(&block)
      end
      self
	  end
    
    def set_tag_list(tag_order_array)      
      @tag_list = tag_order_array.map{|e| e.to_sym}
    end
    
	  # look for graphic with same tag as content_hash key
	  # and replace the graphic content with the content_hash value.
	  def set_content(first_item)
	    content = first_item[:para_string] || first_item[:string]
	    return unless content
	    content.sub!(/^=*\s/, "") if content=~/^=*\s/
	    content.sub!(/^#*\s/, "") if content=~/^#*\s/
	    v = content.split("\n")  
	    #TODO fix this 
      # v.map{|e| e.gsub("\\n", "\n").gsub("\\u{2611}", "\u{2611}")}
      # puts "v;#{v}"
      content_hash = Hash[@tag_list.zip v]
      # puts "content_hash:#{content_hash}"
      @graphics.each do |graphic|
        if graphic.tag && @tag_list.include?(graphic.tag.to_sym)
          if graphic.is_a?(Text)
            graphic.set_text_string(content_hash[graphic.tag.to_sym])
          elsif graphic.is_a?(Image)
            if graphic.local_image
              graphic.local_image = content_hash[graphic.tag.to_sym]
            elsif graphic.image_path
              graphic.image_path = content_hash[graphic.tag.to_sym]
            end
          end
        end
      end
	  end
	end

end