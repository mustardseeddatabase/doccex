class Doccex::Base
  def tmp_file
    Rails.application.root.join('tmp/tmp_file.docx')
  end

  def zip_package(dir)
    FileUtils.cd(dir) do
      system "zip -qr #{tmp_file} . -x \*.DS_Store \*.git/\* \*.gitignore \*.gitkeep"
    end
    cleanup(dir)
  end

  def read_zipfile
    string = File.read(tmp_file)
    cleanup(tmp_file)
    string
  end

  def cleanup(*files)
    files.each do |f|
      FileUtils.send(File.directory?(File.new(f)) ? "rm_r" : "rm",f)
    end
  end
end
