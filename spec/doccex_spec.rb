require 'spec_helper'

describe "dummy application" do
  it "should exist" do
    Rails.application.should be_kind_of Dummy::Application
  end
end

describe "docx request sends an MSWord document as a file", :type => :request do
  before do
    visit "/test.html"
    click_link "Word document"
  end

  it "contains appropriate headers" do
    headers = page.response_headers
    headers['Content-Type'].should include "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    headers['Content-Disposition'].should == 'attachment; filename="test_doc.docx"'
    headers['Content-Transfer-Encoding'].should == 'binary'
  end
end

describe "pdf mime type" do
  Mime::DOCX.to_sym.should ==:docx
  Mime::DOCX.to_s.should == "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
end

describe "Doccex::Document instance methods" do
  describe "#create_template method" do
    it "creates a blank document filesystem in the tmp directory" do
      Doccex::Document.new({}).create_template
      [Rails.application.root.join("tmp/docx"), Rails.application.root.join("tmp/docx/_rels"), Rails.application.root.join("tmp/docx/docProps"), Rails.application.root.join("tmp/docx/word")].each do |dir|
        File.exists?(dir).should be_true
        File.directory?(dir).should be_true
      end
      [Rails.application.root.join("tmp/docx/[Content_Types].xml"), Rails.application.root.join("tmp/docx/word/document.xml"), Rails.application.root.join("tmp/docx/word/fontTable.xml"), Rails.application.root.join("tmp/docx/word/settings.xml"), Rails.application.root.join("tmp/docx/word/styles.xml"), Rails.application.root.join("tmp/docx/word/webSettings.xml")].each do |file|
        File.exists?(file).should be_true
        File.file?(file).should be_true
      end
    end
  end

  describe "#cleanup method" do
    it "removes docx directory from /tmp" do
      doc = Doccex::Document.new({})
      doc.create_template
      File.exists?(Rails.application.root.join("tmp/docx")).should be_true
      doc.cleanup(Rails.application.root.join("tmp/docx"))
      File.exists?(Rails.application.root.join("tmp/docx")).should be_false
    end
  end

  describe "#zip_package method" do
    it "creates a file with the passed-in filename in the tmp directory" do
      doc = Doccex::Document.new({})
      doc.create_template
      doc.zip_package(Rails.application.root.join("tmp/docx"))
      File.exists?(Rails.application.root.join("tmp/test_doc.docx")).should be_true
    end
  end

  describe "#contents method" do
    it "creates the document.xml file in the document filesystem" do
      doc = Doccex::Document.new({})
      doc.create_template
      contents = "<bish><bash><bosh>Kablooie</bosh></bash></bish>"
      doc.contents contents
      File.exists?(Rails.application.root.join("tmp/docx/word/document.xml")).should be_true
      File.read(Rails.application.root.join("tmp/docx/word/document.xml")).should == contents
    end
  end

  describe "#footer method" do
    it "creates the footer1.xml file in the document filesystem" do
      doc = Doccex::Document.new({})
      doc.create_template
      footer = "<bish><bash><bosh>Kablooie</bosh></bash></bish>"
      doc.footer footer
      File.exists?(Rails.application.root.join("tmp/docx/word/footer1.xml")).should be_true
      File.read(Rails.application.root.join("tmp/docx/word/footer1.xml")).should == footer
    end
  end
end

describe "Doccex::Rels" do
  describe "after initialization" do
    it "should have a relationships property, which is an array of hashes of target, type and id values" do
      rel = Doccex::Rels.new
      rel.relationships.should be_kind_of(Array)
      rel.relationships.size.should == 5
      rel.relationships.each do |r|
        r.should be_kind_of(Hash)
        r.has_key?(:target).should be_true
        r.has_key?(:type).should be_true
        r.has_key?(:id).should be_true
      end
    end
  end

  describe "next_id method" do
    it "should add a relationship as specified in the argument, with the next id in sequence" do
      rel = Doccex::Rels.new
      rel.next_id(:printer).should == "rId6"
      rel.relationships.size.should == 6
    end
  end

  describe "render_to_string method" do
    it "should create a string of rels file xml contents" do
      rel = Doccex::Rels.new
      rel.render_to_string.should == <<-REL
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
  <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/settings" Target="settings.xml"/>
  <Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/webSettings" Target="webSettings.xml"/>
  <Relationship Id="rId4" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/fontTable" Target="fontTable.xml"/>
  <Relationship Id="rId5" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme" Target="theme/theme1.xml"/>
</Relationships>
      REL
    end
  end

  describe "create_file method" do
    it "should create a file in the document filesystem called document.xml.rels" do
      rel = Doccex::Rels.new
      rel.create_file
      File.exists?(Rails.application.root.join('tmp/docx/word/_rels/document.xml.rels')).should be_true
    end
  end
end
