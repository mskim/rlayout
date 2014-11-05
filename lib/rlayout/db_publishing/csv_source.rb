require 'csv'

module RLayout
  
  class CSVParsor    
    def self.parse(csv_path)
        unless File.exists?(csv_path)
          puts "#{csv_path} doesn't exist ..."
          return nil
        end
        result = nil
        if csv_path =~/_mac.csv$/
          result = NSString.alloc.initWithContentsOfFile(csv_path, encoding:NSUTF8StringEncoding, error:nil)
        elsif csv_path =~/_pc.csv$/
          #Korean (Windows, DOS) -2147482590
          result = NSString.alloc.initWithContentsOfFile(csv_path, encoding:-2147482590, error:nil)
        else
          result = NSString.alloc.initWithContentsOfFile(csv_path, encoding:NSUTF8StringEncoding, error:nil)
        end
        rows=[]
        if result  # if reading was successful
          rows = CSV.parse(result)
          rows.pop if rows.last.length == 0
          return rows
        else
          puts "could not open the file #{path}"
        end
        rows
    end    
  end
end
  