
# HeadingContainer is a variation of Heading.
# HeadingContainer is used for creating non-stacking complex Headings, 
# a complex free form Headings, Newspaper, Study Book, Magazine, Catalog
# Template is created with tags and replace by content with set_content
#
module RLayout

	class HeadingContainer < Container
  
	  def initialize(options={}, &block)
	    options[:layout_expand] = :width unless options[:layout_expand]
	    super
	    if block
        instance_eval(&block)
      end
	    self
	  end
  
	  # look for graphics with same tag as content_hash element
	  # and replace the content with new one.
	  def set_content(content_hash)
	    keys = content_hash.keys
      @graphics.each do |graphic|
        if graphic.tag && keys.include?(graphic.tag.to_sym)
          if graphic.is_a?(Text)
            graphic.set_text(content_hash[graphic.tag.to_sym])
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