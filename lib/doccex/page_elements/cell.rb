class Doccex::PageElements::Cell < String
  def initialize(context, col, obj_name, obj)
    super context.render(:partial => 'doccex/cell.xml', :locals => {:col => col, :obj_name => obj_name, :obj => obj})
  end
end
