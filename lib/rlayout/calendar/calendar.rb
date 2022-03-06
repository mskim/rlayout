module RLayout

  class Calendar  < StyleGuide
    attr_reader :year, :titile, :events

    def initialize(options={})
      super
      load_envents
      
      self
    end

    def event_csv_path
      @document_path + "/events.csv"
    end

    def default_events
      s=<<~EOF
      date,title,description
      1-1,NewYear, NewYear holiday
      4-1,AprilFools, April Fool's holiday
      5-1,Mayday, May labor holiday
      12-25,Christmas, Christmas holiday
      1-29,Min Soo Birthday, Min Soo's Birthday
      3-10,Sung Kun Birthday, Sung Kun's Birthday
      10-30,Jeeyoon's Birthday, Jeeyoon's Birthday
      EOF
    end

    def load_envents
      if File.exist?(event_csv_path)
        @events = File.open(event_csv_path, 'r'){|f| f.read}
      else
        @events = default_events
        File.open(event_csv_path, 'w'){|f| f.write default_events}
      end
    end

    def default_layout_rb

    end

    def default_text_style
      # title
      # subtitle
      # body
      # cell_day
      # cell_week
      # cell_sunday
      # divided_cell_day
    end
  end




end