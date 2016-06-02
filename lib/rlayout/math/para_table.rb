
# ParaTable is combination of Table and Paragraph. It is placed in TextBox column.
# Source is read from csv file.
# Table can be broken into mutiple columns.

module RLayout
  attr_accessor :csv_path, :table_style
	class ParaTable
	  
	  def initialize(options={})
	    @csv_path     = options[:csv_path]
	    if options[:table_style_path]
	      @table_style  = File.open(options[:table_style_path], 'r'){|f| f.read}
	    end
	    
	    self
	  end
	end
	
end