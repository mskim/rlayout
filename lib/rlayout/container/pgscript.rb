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
      Rectangle.new(self, options)
    end

    def text(options={})
      Text.new(self, options)
    end

    def circle(options={})
      Circle.new(self, options)
    end

    def container(options={}, &block)
      Container.new(self, options, &block)
    end

    def random_graphics(number)
      add_graphic(Graphic.random_graphics(number))
    end



    # place graphis as float in using grid_frame
    def float(klass, grid_frame, options={})
      if klass.class == String
        # single float

      elsif klass.class == Array
        # multiple floats

      end
    end

    def stack(graphic, options={})

    end

    def stack_h(graphic, options={})

    end

    def stack_v (graphic, options={})
      add_graphic(graphic)
    end

    def place(graphic, grid_frame)

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
          Container.new(self, options)
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
