class Doccex::Base
  def tmp_file
    tmp_dir.join('tmp_file.docx')
    # Rails.application.root.join('tmp/tmp_file.docx')
  end

  def zip_package(dir)
    FileUtils.cd(dir) do
      # -q 'quiet', -r 'recursive', tmp_file = resulting zipped file
      # zip cmd leavs tmp_dir with two entries:
      #   docx (dir)
      #   tmp_file.docx (zipped file)
      system "zip -qr #{tmp_file} . -x \*.DS_Store \*.git/\* \*.gitignore \*.gitkeep"
    end
    cleanup(dir)
  end

  def read_zipfile
    string = File.read(tmp_file)
    cleanup(tmp_dir)
    string
  end

  def cleanup(*files)
    files.each do |f|
      FileUtils.send(File.directory?(File.new(f)) ? 'rm_r' : 'rm', f)
    end
  end
end
