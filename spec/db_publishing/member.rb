module RLayout

  # MemberCard works similar to TextToken
  #
  class MemberCard < Container
    attr_reader :name, :image_folder, :template, :card_style

    def initialize(options={})
      @name         = options[:name]
      @image_folder = options[:image_folder]
      @card_style   = options[:card_style]
      @template     = options[:template]
      layout_card
      self
    end

    def layout_card

    end

  end

  # MemberGroup works similar to Paragraph
  # it layouts out members as tokens in LineFragment
  class MemberGroup
    attr_reader :member_list
    def initialize(options={})
      @member_list  = option[:member_list]
      @members      = []
      create_members
    end

    def create_members

    end

    def layout_lines(current_line, options={})
        
    end

  end

end