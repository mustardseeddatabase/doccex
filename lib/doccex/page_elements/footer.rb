class Doccex::PageElements::Footer
  def initialize(xml_string) # unlike other page elements, footers are contained in a separate file
    File.open(Rails.application.root.join('tmp/docx/word/footer1.xml'), 'w') {|file| file.write(xml_string)}
  end
end
