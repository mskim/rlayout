# CategoryTree
# I am using CategoryTree to convert flat csv address data into nested tree form for layout
# @category_tree is a combination of Hash and Array in nested tree form
# with each category as Hash key and each Array as members in that category.

module RLayout
  
  class CategoryTree    
    attr_accessor :rows, :category_tree, :head_row
    def initialize(options={})
      if options[:rows]
        @rows = options[:rows]
        puts @head_row = @rows.shift          
        # remove emtpty row
        @rows.pop if @rows.last.length == 0
      elsif options[:csv_path]
        unless File.exists?(csv_path)
          puts "#{csv_path} doesn't exist ..."
          return self
        end
        if csv_path =~/_mac.csv$/
          result = NSString.alloc.initWithContentsOfFile(csv_path, encoding:NSUTF8StringEncoding, error:nil)
        elsif csv_path =~/_pc.csv$/
          #Korean (Windows, DOS) -2147482590
          result = NSString.alloc.initWithContentsOfFile(csv_path, encoding:-2147482590, error:nil)
        else
          result = NSString.alloc.initWithContentsOfFile(csv_path, encoding:NSUTF8StringEncoding, error:nil)
        end
        @rows=[]
        if result  # if reading was successful
          @rows = CSV.parse(result)
          puts @head_row = @rows.shift          
          # remove emtpty row
          @rows.pop if @rows.last.length == 0
        else
          puts "could not open the file #{path}"
        end
      end
      
      create_catrgory_tree(options)
      self
    end    
    
    # create_catrgory_tree 
    # tree_depth
    def create_catrgory_tree(options={})
      puts "@rows.first.length:#{@rows.first.length}"
      current_categry = @rows.first.first
      puts "current_categry:#{current_categry}"
      current_members = []
      @category_tree = {}
      @category_tree[current_categry] = current_members
      @rows.each do |row|
        if row[0] == current_categry
          row.shift  # get rid of category field
          current_members << row
        else
          current_categry = row[0]
          current_members = []
          @category_tree[current_categry] = current_members
          row.shift  # get rid of category field
          current_members << row
        end
      end
    end
  end
end
