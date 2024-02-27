ActionController::Renderers.add :docx do |filename, options|
  if options[:from_template]
    doc = Doccex::Template.new(options[:template], view_assigns)
  else
    tmp_dir = Rails.application.root.join('tmp', SecureRandom.alphanumeric)
    Dir.mkdir(tmp_dir)
    doc = Doccex::Document.new(view_assigns, tmp_dir: tmp_dir)
    @rels = Doccex::Rels.new(tmp_dir: tmp_dir)
    options.merge!({:rels => @rels})
    doc.contents render_to_string(options) # looks for a <:action_name>.builder file, should be provided by host application
    @rels.create_file
  end

  send_data doc.render_to_string, :filename => "#{filename}.docx",
    :type => "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    :disposition => "attachment"
end
