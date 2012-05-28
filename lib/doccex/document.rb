class Doccex::Document
  def initialize(view_assigns)
    view_assigns.keys.each do |key|
      instance_variable_set("@"+key, view_assigns[key])
    end
    create_template
  end

  def contents(string)
    File.open(Rails.application.root.join('tmp/docx/word/document.xml'), 'w') {|file| file.write(string)}
  end

  def footer(string)
    File.open(Rails.application.root.join('tmp/docx/word/footer1.xml'), 'w') {|file| file.write(string)}
  end

  def tmp_file
    Rails.application.root.join('tmp/tmp_file.docx')
  end

  def render_to_string
    source = Rails.application.root.join('tmp/docx')
    zip_package(source)
    read_zipfile
  end

  def create_template
    FileUtils.cp_r(File.expand_path('../templates/docx',__FILE__), Rails.application.root.join('tmp'))
  end

  def cleanup(*files)
    files.each do |f|
      FileUtils.send(File.directory?(File.new(f)) ? "rm_r" : "rm",f)
    end
  end

  def zip_package(dir)
    FileUtils.cd(dir) do
      system "zip -qr #{tmp_file} . -x \*.DS_Store \*.git/\* \*.gitignore \*.gitkeep"
    end
    #cleanup(dir)
  end

  def read_zipfile
    string = File.read(tmp_file)
    cleanup(tmp_file)
    string
  end

end
