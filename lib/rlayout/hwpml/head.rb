
module RLayout
	class Head
	  attr_accessor :root, :doc_summary, :doc_setting, :mapping_table
	  def initialize(hwpml, options={})
	    doc = Nokogiri.html(hwpml)
	    @doc_summary                    = {}
	    @doc_summary[:TITLE]            = doc('TITLE')
	    @doc_summary[:SUBJECT]          = doc('TITLE')
	    @doc_summary[:AUTHOR]           = doc('TITLE')
	    @doc_summary[:DATE]             = doc('TITLE')
	    @doc_summary[:KEYWORDS]         = doc('TITLE')
	    @doc_summary[:COMMENTS]         = doc('TITLE')
	    @doc_summary[:FORBIDDENSTRING]  = doc('TITLE')
	    
	    @doc_setting = {}
	    @mapping_table = {}
	    self
	  end
	  
	  
	  
	end


end