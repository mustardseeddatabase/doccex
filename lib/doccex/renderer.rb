ActionController::Renderers.add :docx do |filename, options|
  doc = Doccex::Document.new(view_assigns)
  @rels = Doccex::Rels.new
  options.merge!({:rels => @rels})
  doc.contents render_to_string(options) # looks for a <:action_name>.builder file, should be provided by host application
  @rels.create_file
  send_data doc.render_to_string, :filename => "#{filename}.docx",
    :type => "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    :disposition => "attachment"
end
