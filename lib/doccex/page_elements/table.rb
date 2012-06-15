class Doccex::PageElements::Table < String
  def initialize(context, options)
    collection = options[:collection] # the collection is iterated and each member passed in to a row
    obj_name   = options[:obj_name] # a symbol denoting the variable name on which methods are called in the row cells
    cols       = options[:cols] # an array of hashes, each representing a column, with width provided in twips values so [{:twips = > 2883},{:twips = > 3330}], a twips is a twentieth of a point, so 72 x 20 per inch.
    row        = options[:row] # the arguments defining the rows are passed through the table instance

    rows = collection.inject("") do |str,collection_item|
      # the options for row are:
      # :height, takes a hash with key :twips and value is the table height in twips units
      # :hRule, how the height should be used, key is 'exact' or 'atLeast' when there is a height specified, else hRule may be 'auto'
      # :cols, an array of hashes specifying the cell attributes:
      #      :align, 'left', 'center', or 'right'
      #      :twips, the width attribute, in twips units
      #      :cell_contents, a string pointing to a .xml.builder file in the host application. In the cell_contents.xml.builder
      #      files, the variables from the collection are interpolated, using the variable name passed in as obj_name
      str += context.render(:partial => 'doccex/table_row', :formats => [:xml], :locals => {:obj_name => obj_name, :obj => collection_item, :row => row, :cols => cols})
    end
    super context.render(:partial => 'doccex/table', :formats => [:xml], :locals => {:rows => rows, :cols => cols})
  end
end
