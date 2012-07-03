class Doccex::PageElements::Title < String
  def initialize(context, text)
    super context.render(:partial => 'doccex/title', :formats => [:xml], :locals => {:text =>text})
  end
end
