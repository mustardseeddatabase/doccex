class Doccex::PageElements::TableHeader < String
  def initialize(context, array, row, cols)
    super context.render(:partial => 'doccex/table_header',
                         :formats => [:xml],
                         :locals => {:array => array, :row => row, :cols => cols})
  end
end
