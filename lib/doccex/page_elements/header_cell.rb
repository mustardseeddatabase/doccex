class Doccex::PageElements::HeaderCell < String
  def initialize(context, string, col)
    super context.render(:partial => 'doccex/header_cell', :formats => [:xml], :locals => {:string => string, :col => col})
  end
end
