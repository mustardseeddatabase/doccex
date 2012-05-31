class Doccex::PageElements::Image < String
  def initialize(context, image_file)
    rels = context.instance_variable_get(:@rels)
    locals = {:rid => rels.next_id(:image, image_file), :index => rels.next_image_index }
    super context.render(:partial => 'doccex/image.xml', :locals => locals)
  end
end
