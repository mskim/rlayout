module RLayout
  class Graphic
    # graphic
    def node_path
      return "0" unless @parent || @document
      if @parent
        return @parent.node_path + "_" + @parent.graphics.index(self).to_s 
      elsif @document
        return @document.pages.index(self).to_s 
      end
      ""
    end
    
    def node_depth
      node_path.split("_").length
    end
    
    def node_tree
      [node_path, "leaf_node"]
    end
  end
  
  class Container < Graphic
    # array of node_path 
    # container
    def node_tree
      node_tree = []
      node_tree << [node_path, "collapsed"]
      if @graphics && @graphics.length > 0
        @graphics.each do |graphic|
          node_tree += graphic.node_tree
        end
      end
      node_tree
    end
  end
  
end
