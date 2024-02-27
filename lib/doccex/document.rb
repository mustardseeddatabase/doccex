class Doccex::Document < Doccex::Base
  attr_accessor :tmp_dir

  def initialize(view_assigns, tmp_dir:)
    view_assigns.keys.each do |key|
      instance_variable_set("@"+key, view_assigns[key])
    end
    @tmp_dir = tmp_dir
    create_template
  end

  def contents(string)
    File.open(tmp_dir.join('docx/word/document.xml'), 'w') {|file| file.write(string)}
  end

  def render_to_string
    source = tmp_dir.join('docx')
    zip_package(source)
    read_zipfile
  end

  def create_template
    FileUtils.cp_r(File.expand_path('../templates/docx',__FILE__), tmp_dir)
  end
end
