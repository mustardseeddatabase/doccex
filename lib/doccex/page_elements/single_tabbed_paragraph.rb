class Doccex::PageElements::SingleTabbedParagraph < String
  def initialize(context, options)
    super context.render( :partial => 'doccex/single_tabbed_para',
                          :formats => [:xml],
                          :locals => { :tab => options[:tab], :contents => options[:contents] })
  end
end
