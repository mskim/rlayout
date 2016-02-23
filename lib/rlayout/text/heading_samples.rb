
# Grid
# grid_base = [3,3]
# grid_cells = Array of grid cell frame
# reset when set_frame is called

module RLayout

  class QuizHeaing < Container
    attr_accessor :date, :logo, :subject, :teacher
  end
  
  class NewsHeading < Container
    attr_accessor :date, :news_logo, :left_ad, :right_ad, :info_box
    def initialize(parent_graphic, options={}, &block)
      @grid_base = @options.fetch(:grid_base, [7,1])
      super
      @left_ad = Image.new(self, parent_grid: true, grid_frame:[0,1,1,1])
      @right_ad = Image.new(self, parent_grid: true, grid_frame:[-1,0,1,0.8])
      @data = Image.new(self, parent_grid: true, grid_frame:[-1,0.8,1,0.1])
      @news_logo = Image.new(self, parent_grid: true, grid_frame:[2,0,4,1])
      
    end
  end
  
end
