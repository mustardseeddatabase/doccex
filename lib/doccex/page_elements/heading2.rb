class Doccex::PageElements::Heading2 < String
  def initialize(context, text)
    super context.render(:partial => 'doccex/heading2', :formats => [:xml], :locals => {:text =>text})
  end
end
