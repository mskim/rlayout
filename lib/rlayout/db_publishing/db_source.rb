
#  Created by Min Soo Kim on 2014/11/4
#  Copyright 2014 SoftwareLab. All rights reserved.


# This is base class for connecting to database
# There are two ways of fatching data, 
# One is direct connection, and the other way is through REST API
# We have bundch of subclasses of this for specific database field setup
# MemberSource for memership database
# ProductSource for product database
# AdSource for box ad database

module RLayout
  class DBSource
    attr_accessor :date, :status, :categories, :published, :commnets
    attr_accessor :heading, :db_items
    attr_accessor :current_item_index
    attr_accessor :connection_type  # db_connection, rest
    attr_accessor :rest_fetch_url #:rest_url, :rest_user, :rest_password, 
    attr_accessor :host, :user, :password, :db_name, :connected
    
    def initialize(options={})
      @heading      = options.fetch(:heading, nil)
      @published    = heading.fetch(:published, false)
      @connection_type = options(:connection_type, "rest")
      @db_items     = []
      if options[:connection_type] == "db_connection"
        @host         = options[:host]
        @user         = options[:user]
        @password     = options[:password]
        @db_name      = options[:db_name]
        @port         = options[:port]
      else
        @rest_fetch_url = options[:rest_fetch_url]
      end
      
      fetch
      @current_item_index = 0
      
      self
    end
    
    def fetch_rest
      
    end
    
    def connect_to_db
      
    end
    
    def fetch_db (options={})
      if @connected
        
      else
        connect_to_db
        
      end
    end
        
    def to_hash
      h = {}
      h[:heading]   = @heading
      h[:db_items]  = @db_items
      h
    end
        
    def done_layout?
      @current_item_index >= @db_items.length
    end
    
    def self.open(path)
      story_hash = YAML::load_file(path)
      Story.new(story_hash)
    end
    
    def save_stroy(path)
      unless path =~/.yml$/
        path += ".yml"
        system("mkdir -p #{File.dirname(path)} ") unless File.exists?(File.dirname(path))
        File.open(path, 'w'){|f| f.write to_hash.to_yaml}
      end
    end
        

  end
  
end


