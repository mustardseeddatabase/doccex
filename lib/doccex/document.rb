class Doccex::Document < Doccex::Base
  def initialize(view_assigns)
    view_assigns.keys.each do |key|
      instance_variable_set("@"+key, view_assigns[key])
    end
    create_template
  end

  def contents(string)
    File.open(Rails.application.root.join('tmp/docx/word/document.xml'), 'w') {|file| file.write(string)}
  end

  def render_to_string
    source = Rails.application.root.join('tmp/docx')
    zip_package(source)
    read_zipfile
  end

  def create_template
    FileUtils.cp_r(File.expand_path('../templates/docx',__FILE__), Rails.application.root.join('tmp'))
  end

end
