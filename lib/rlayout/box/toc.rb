module RLayout
  
  class Toc < Container
    attr_accessor :column_count, :toc_text, :toc_text_path, :item_rows
    def initialize(options={})
      super
      @column_count = options.fetch(:column_count, 1)
      if options[:toc_text_path]
        unless File.exist?(options[:toc_text_path])
          puts "toc_text: #{options[:toc_text_path]} doesn't exist!!!"
        end
        @toc_text = File.open(options[:toc_text_path], 'r'){|f| f.read}
      elsif options[:toc_text]
        @toc_text = options[:toc_text]
      else
        puts "No toc_text!!!"
      end
      rows = toc_text.split("\n")
      @item_rows = []
      rows.each do |row_text|
        @item_rows << LeaderRow.new(row_text:row_text)
      end
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
end