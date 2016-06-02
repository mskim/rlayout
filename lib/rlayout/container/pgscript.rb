# PageScript Verbs

#  text
#  image
#  rect
#  circle
#  round_rect
#  line

#
#  float
#  split
#  split_v
#  split_h

#  container
#  text_box
#  heading


module RLayout
  class Container < Graphic

    def rect(options={})
      options[:parent] = self
      Rectangle.new(options)
    end
    
    def rectangle(options={})
      options[:parent] = self
      Rectangle.new(options)
    end
    
    def round_rect(options={})
      options[:parent] = self
      RoundRect.new(options)
    end
    
    def text(string, options={})
      options[:parent] = self
      options[:text_string] = string
      Text.new(options)
    end
    
    def text_runs(strings_array, atts_array, options={})
      options[:parent] = self
      options[:text_string_array] = strings_array
      options[:text_atts_array]   = atts_array
      Text.new(options)
    end
    
    def text_train(text_string_array, atts_array, options={})
      options[:parent] = self
      options[:text_string_array] = text_string_array.split(" ")
      options[:text_atts_array]   = atts_array
      TextTrain.new(options)
    end
    
    def char_train(string, atts_array)
      options = {}
      options[:parent] = self
      options[:text_string_array] = string.split("")
      options[:text_atts_array]   = atts_array
      TextTrain.new(options)
    end
    
    def circle(options={})
      options[:parent] = self
      Circle.new(options)
    end

    def image(options={})
      options[:parent] = self
      Image.new(options)
    end
    
    def line(options={})
      options[:parent] = self
      Line.new(options)
    end
    
    def container(options={}, &block)
      options[:parent] = self
      Container.new(options, &block)
    end

    def bar(options={}, &block)
      options[:parent] = self
      Bar.new(options, &block)
    end

    def random_graphics(number)
      add_graphic(Graphic.random_graphics(number))
    end
        
    def text_box(options={}, &block)
      options[:parent] = self
      TextBox.new(options)
    end
    
    def memo(options={})
      options[:parent] = self
      MemoArea.new(options)
    end
    
    def heading(options={}, &block)
      options[:parent] = self
      Heading.new(options, &block)
    end
    
    def table(options={}, &block)
      options[:parent] = self
      Table.new(options, &block)
    end
    
    def item_list(options={}, &block)
      options[:parent] = self
      ItemList.new(options, &block)
    end
    
    def grid_box(options={}, &block)
      options[:parent] = self
      GridBox.new(options, &block)
    end
    
    # place graphis as float using grid_frame
    def float(klass, grid_frame, options={})
      if klass.class == String
        # single float

      elsif klass.class == Array
        # multiple floats

      end
    end
    
    def stack_v (graphic, options={})
      add_graphic(graphic)
    end
    
    # place graphic by replacing place holder with same tag
    # this is how we use layout template
    # by creating place holder with tag and replacing them with user graphic
    def place(graphic, options={})
      if graphic.class == Array
        graphic.each do |g|
          next unless g.tag
          replace_graphic(g)
        end
      else
        return unless graphic.tag
        replace_graphic(graphic)
      end
      relayout!
      self
    end
    
    def replace_graphic(graphic)
      tag = graphic.tag
      @graphics.each do |place_folder|
        if place_folder.tag == tag
          index = @graphics.index(place_folder)
          frame_rect = place_folder.frame_rect
          @graphics.delete_at(index)
          @graphics.insert(index, graphic)
          graphic.set_frame(frame_rect) # set_frame triggers content reloay
        end
      end
      @floats.each do |place_folder|
        if g.tag == tag
          index = @graphics.index(place_folder)
          frame_rect = place_folder.frame_rect
          @floats.delete_at(index)
          @floats.insert(index, graphic)
          graphic.set_frame(frame_rect) # set_frame triggers content reloay
        end
      end
    end

    def split(number=2, options={})
      @layout_direction = options.fetch(:layout_direction, "vertical")
      if options[:layout_space]
        # layout_space applies to self, not to children
        @layout_space = options[:layout_space]
        options.delete(:layout_space)
      end

      if number.class == Fixnum
        number.times do
          options[:parent] = self
          Container.new(options)
        end
      elsif number.class == Array
        number.each do |attribute|
          if attribute.class == Fixnum

          elsif attribute.class == Hash

          end
        end

      end

      # klasses are passed in Array
      if options[:klass_array]

      end
      # fill_colors is in Array

      if options[:fill_color_array]

      end

      relayout!

    end

    # set layout_direction = "vertical"
    def split_v(number=2, options={})
      options[:layout_direction] = "vertical"
      split(number, options)
    end

    # layout_direction = "horizontal"
    def split_h(number=2, options={})
      options[:layout_direction] = "horizontal"
      split(number, options)

    end


    # it should go to graphics
    # def page
    #
    # end
    #
    # def document
    #
    # end

    def syblings

    end

    def child_at(node_tree)

    end

    def children

    end

    def decendents

    end

    def decendents_at(node_tree)

    end
  end


end
