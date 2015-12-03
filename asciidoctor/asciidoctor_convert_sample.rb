# Examples
#
EOL = "\n"

require 'asciidoctor'
require 'yaml'

class TextConverter
  include Asciidoctor::Converter
  register_for 'text'
  def initialize backend, opts
    super
    outfilesuffix '.yml'
  end
  
  def convert node, transform = nil
    case (transform ||= node.node_name)
    when 'document'
      result = []
      result << "---"
      result << "title: #{node.doctitle}" if node.doctitle
      result << node.content
      result * "\n\n"
    when 'preamble'
      node.content            
    when 'section'
      # ["#{node.level}: #{node.title}", node.content] * "\n\n"
      [{"section #{node.level}": node.title}, node.content] * "\n"
    when 'paragraph'
      node.content.tr("\n", ' ') << "\n"
    when 'table'
      result = {}
      [:head, :foot, :body].select {|tsec| !node.rows[tsec].empty? }.each do |tsec|
        result[tsec] = []
        node.rows[tsec].each do |row|
          row_array = []
          row.each do |cell|
            if tsec == :head
              cell_content = cell.text
            else
              cell_content = cell.text
            end
            cell_hash = {text_string: cell_content}
            cell_hash[:colspan]  = cell.colspan if cell.colspan && cell.colspan != "1"
            cell_hash[:rowspan]  = cell.rowspan if cell.rowspan && cell.rowspan != "1"
            cell_hash[:halign]   = cell.attr 'halign' 
            cell_hash[:valign]   = cell.attr 'valign'
            row_array << cell_hash
          end
          result[tsec] << row_array
        end
      end
      return_value = {table: result}
      return_value.to_yaml
    else
      if transform.start_with? 'inline_'
        node.text
      else
        %(<#{transform}>\n)
      end
    end
  end
end

Asciidoctor.convert_file('story2.adoc', backend: :text)
  