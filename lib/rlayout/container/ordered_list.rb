# OrderedList

module RLayout

  # List Item
  class ListItem < Container
    attr_accessor :bullet_type, :number_type, :level, :text

    def initialize(parent_graphic, options={})
      @bullet_type  = options.fetch(:bullet_type, "dot")
      @number_type  = options.fetch(:bullet_type, "alpha")
      @level        = options.fetch(:level, 0)
      @text         = options.fetch(:text, "")
      super

      self
    end
  end

  # given asciitoctot syntex ordered list text
  # create ordered list with list item
  class OrderedList < Container
    attr_accessor :number_type


  end

  class UnorderedList < Container



  end
end
