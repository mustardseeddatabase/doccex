class Doccex::PageElements::Heading1 < String
  def initialize(context, text)
    super context.render(:partial => 'doccex/heading1', :formats => [:xml], :locals => {:text =>text})
  end
end
