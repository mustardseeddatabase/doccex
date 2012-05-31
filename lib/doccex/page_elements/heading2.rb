class Doccex::PageElements::Heading2 < String
  def initialize(context, text)
    super context.render(:partial => 'doccex/heading2.xml', :locals => {:text =>text})
  end
end
