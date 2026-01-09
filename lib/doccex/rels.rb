require 'builder'

class Doccex::Rels
  attr_accessor :relationships, :footerReference, :headerReference, :tmp_dir, :max_id

  OPEN_XML_URI = 'http://schemas.openxmlformats.org/officeDocument/2006/relationships/'

  RELATIONSHIPS = { styles: { type: "#{OPEN_XML_URI}styles", target: 'styles.xml' },
                    settings: { type: "#{OPEN_XML_URI}settings", target: 'settings.xml' },
                    webSettings: { type: "#{OPEN_XML_URI}webSettings", target: 'webSettings.xml' },
                    fontTable: { type: "#{OPEN_XML_URI}fontTable", target: 'fontTable.xml' },
                    theme: { type: "#{OPEN_XML_URI}theme", target: 'theme/theme1.xml' },
                    footer: { type: "#{OPEN_XML_URI}footer", target: 'footer1.xml' },
                    printer: { type: "#{OPEN_XML_URI}printerSettings",
                               target: 'printerSettings/printerSettingsINDEX.bin' },
                    image: { type: "#{OPEN_XML_URI}image" },
                    footnotes: { type: "#{OPEN_XML_URI}footnotes", target: 'footnotes.xml' },
                    endnotes: { type: "#{OPEN_XML_URI}endnotes", target: 'endnotes.xml' },
                    header: { type: "#{OPEN_XML_URI}header", target: 'header1.xml' },
                    customXml: { type: "#{OPEN_XML_URI}customXml", target: 'ink/ink1.xml' } }

  def initialize(tmp_dir:)
    @tmp_dir = tmp_dir
    @relationships = []
    @printer_index = 1
    @image_index = 0
    @max_id = 0
  end

  def next_id(type, *args)
    @max_id += 1
    new_id = "rId#{@max_id}"
    new_rel = RELATIONSHIPS[type]
    if type == :footer
      @relationships << { id: new_id, type: new_rel[:type], target: new_rel[:target] }
      @footerReference = new_id
    elsif type == :header
      @relationships << { id: new_id, type: new_rel[:type], target: new_rel[:target] }
      @headerReference = new_id
    elsif type == :printer
      target = new_rel[:target].dup.gsub!(/INDEX/, @printer_index.to_s)
      @relationships << { id: new_id, type: new_rel[:type], target: target }
      copy_printerSettings
      @printer_index += 1
    elsif type == :image
      @image_index += 1
      target = Rails.root.join(args[0]).to_s.match(/media.*/)[0] # => 'media/filename.png'
      @relationships << { id: new_id, type: new_rel[:type], target: target }
    else # footnotes, endnotes
      @relationships << { id: new_id, type: new_rel[:type], target: new_rel[:target] }
    end
    new_id
  end

  def next_image_index
    @image_index
  end

  def copy_printerSettings
    system "cp #{tmp_dir.join('docx/word/printerSettings/printerSettings1.bin')} #{tmp_dir.join("docx/word/printerSettings/printerSettings#{@printer_index}.bin")}",
           out: File::NULL, err: File::NULL
  end

  def create_relationship(name)
    return unless RELATIONSHIPS[name]

    next_id(name)
  end

  def render_to_string
    xml = Builder::XmlMarkup.new
    xml.instruct! :xml, standalone: 'yes'
    xml.Relationships 'xmlns' => 'http://schemas.openxmlformats.org/package/2006/relationships' do
      @relationships.each do |rel|
        xml.Relationship 'Id' => rel[:id], 'Type' => rel[:type], 'Target' => rel[:target]
      end
    end
  end

  def create_file
    File.open(tmp_dir.join('docx/word/_rels/document.xml.rels'), 'w') { |f| f.write(render_to_string) }
  end
end
