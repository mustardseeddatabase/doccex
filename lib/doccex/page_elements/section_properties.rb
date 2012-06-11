class Doccex::PageElements::SectionProperties < String
  def initialize(context, options = {})
    rels = context.instance_variable_get(:@rels)
    num_cols = options[:num_cols] || 1
    locals = {:rId => rels.next_id(:printer), :num_cols => num_cols}
    locals.merge!({:footerReference => rels.next_id(:footer)}) if options[:include_footer]
    super context.render(:partial => 'doccex/sect_props', :formats => [:xml], :locals => locals)
  end
end


