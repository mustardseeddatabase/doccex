require 'spec_helper'

describe "docx request sends an MSWord document as a file", :type => :request do
  before do
    get '/test.docx'
  end

  it "contains appropriate headers" do
    headers = response.headers
    expect(headers['Content-Type']).to match "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    expect(headers['Content-Disposition']).to eq "attachment; filename=\"test_doc.docx\"; filename*=UTF-8''test_doc.docx"
    expect(headers['Content-Transfer-Encoding']).to eq 'binary'
  end
end

describe "docx mime type" do
  it "registers the mime type" do
    expect(Mime::Type.lookup_by_extension('docx').to_sym).to eq :docx
    expect(Mime::Type.lookup_by_extension('docx').to_s).to eq "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
  end
end

describe "Doccex::Document instance methods" do
  let(:tmp_dir){ Rails.application.root.join('tmp', SecureRandom.alphanumeric)}

  after do
    FileUtils.rm_r(tmp_dir) if File.exists?(tmp_dir)
  end

  describe "#create_template method" do
    it "creates a blank document filesystem in the tmp directory" do
      Doccex::Document.new({}, tmp_dir: tmp_dir ).create_template
      [tmp_dir.join("docx"), tmp_dir.join("docx/_rels"), tmp_dir.join("docx/docProps"), tmp_dir.join("docx/word")].each do |dir|
        expect(File.exists?(dir)).to be true
        expect(File.directory?(dir)).to be true
      end
      [tmp_dir.join("docx/[Content_Types].xml"), tmp_dir.join("docx/word/fontTable.xml"), tmp_dir.join("docx/word/settings.xml"), tmp_dir.join("docx/word/styles.xml"), tmp_dir.join("docx/word/webSettings.xml")].each do |file|
        expect(File.exists?(file)).to be true
        expect(File.file?(file)).to be true
      end
    end
  end

  describe "#cleanup method" do
    it "removes docx directory from /tmp" do
      doc = Doccex::Document.new({}, tmp_dir: tmp_dir)
      doc.create_template
      expect(File.exists?(tmp_dir)).to be true
      doc.cleanup(tmp_dir)
      expect(File.exists?(tmp_dir)).to be false
    end
  end

  describe "#zip_package method" do
    it "creates a file with the passed-in filename in the tmp directory" do
      doc = Doccex::Document.new({}, tmp_dir: tmp_dir)
      doc.create_template
      doc.zip_package(tmp_dir.join("docx"))
      #expect(File.exists?(tmp_dir.join("test_doc.docx"))).to be true
      expect(File.exists?(tmp_dir.join("tmp_file.docx"))).to be true
    end
  end

  describe "#contents method" do
    it "creates the document.xml file in the document filesystem" do
      doc = Doccex::Document.new({}, tmp_dir: tmp_dir)
      doc.create_template
      contents = "<bish><bash><bosh>Kablooie</bosh></bash></bish>"
      doc.contents contents
      expect(File.exists?(tmp_dir.join("docx/word/document.xml"))).to be true
      expect(File.read(tmp_dir.join("docx/word/document.xml"))).to eq contents
    end
  end
end

describe "Doccex::Rels" do
  let(:tmp_dir){ Rails.application.root.join('tmp', SecureRandom.alphanumeric) }

  after do
    FileUtils.rm_r(tmp_dir) if  File.exists?(tmp_dir)
  end

  describe "after initialization" do
    it "should have a relationships property, which is an array of hashes of target, type and id values" do
      rel = Doccex::Rels.new(tmp_dir: tmp_dir)
      expect(rel.relationships).to be_kind_of(Array)
      expect(rel.relationships.size).to eq 5
      rel.relationships.each do |r|
        expect(r).to be_kind_of(Hash)
        expect(r).to have_key(:target)
        expect(r).to have_key(:type)
        expect(r).to have_key(:id)
      end
    end
  end

  describe "next_id method" do
    it "should add a relationship as specified in the argument, with the next id in sequence" do
      rel = Doccex::Rels.new(tmp_dir: tmp_dir)
      expect(rel.next_id(:printer)).to eq "rId6"
      expect(rel.relationships.size).to eq 6
    end
  end

  describe "render_to_string method" do
    it "should create a string of rels file xml contents" do
      rel = Doccex::Rels.new(tmp_dir: tmp_dir)
      string = <<-REL
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
  <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/settings" Target="settings.xml"/>
  <Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/webSettings" Target="webSettings.xml"/>
  <Relationship Id="rId4" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/fontTable" Target="fontTable.xml"/>
  <Relationship Id="rId5" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme" Target="theme/theme1.xml"/>
</Relationships>
      REL
      expect(rel.render_to_string).to eq string.gsub(/\n(\s+)?/,'') # the result has whitespace removed!
    end
  end

  describe "create_file method" do
    it "should create a file in the document filesystem called document.xml.rels" do
      FileUtils.mkdir_p(tmp_dir.join('docx/word/_rels/'))
      rel = Doccex::Rels.new(tmp_dir: tmp_dir)
      rel.create_file
      expect(File.exists?(tmp_dir.join('docx/word/_rels/document.xml.rels'))).to be true
    end
  end
end
