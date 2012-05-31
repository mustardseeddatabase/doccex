class Doccex::PageElements::Table < String
  def initialize(context, options)
    collection = options[:collection] # the collection is iterated and each member passed in to a row
    obj_name   = options[:obj_name] # a symbol denoting the variable name on which methods are called in the row cells
    cols       = options[:cols] # an array of hashes, each representing a column, with width provided in twips values so [{:twips = > 2883},{:twips = > 3330}]
    row        = options[:row]
    rows = collection.inject("") do |str,collection_item|
      str += context.render(:partial => 'doccex/table_row.xml.builder', :locals => {:obj_name => obj_name, :obj => collection_item, :row => row, :cols => cols})
    end
    super context.render(:partial => 'doccex/table.xml', :locals => {:rows => rows, :cols => cols})
  end
end
