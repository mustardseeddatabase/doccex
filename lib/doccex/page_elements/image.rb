class Doccex::PageElements::Image < String
  # the image_file argument is the name of the image file. It must have been copied into
  # the tmp/docx/word/media directory before being passed in (opportunity for improvement here?)
  def initialize(context, image_file)
    rels = context.instance_variable_get(:@rels)
    locals = {:rid => rels.next_id(:image, image_file), :index => rels.next_image_index }
    super context.render(:partial => 'doccex/image', :formats => [:xml], :locals => locals)
  end
end
