class MenuMaker
  attr_accessor :project_path, :template, :menu_csv, :column_count
  
  def initialize(options={})
    @project_path = options[:project_path]
    @template     = Dir.glob("#{@project_path}/**.rb").first
    @menu_csv     = Dir.glob("#{@project_path}/**.csv").first
    
    self
  end
  def layout_content!
    if @column_count > 1
      @item_rows.slice(@column_count) do |coulumn_group|
        LeaderColumn.new(:parent=>self, coulumn_group: coulumn_group)
      end
    else
      LeaderColumn.new(:parent=>self, coulumn_group: coulumn_group)
    end
    puts "items_per_columm:#{items_per_columm}"
  end
  
end
