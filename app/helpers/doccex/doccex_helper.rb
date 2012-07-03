module Doccex
  module DoccexHelper
    def document_namespaces
      {"xmlns:mo" => "http://schemas.microsoft.com/office/mac/office/2008/main", "xmlns:ve" => "http://schemas.openxmlformats.org/markup-compatibility/2006", "xmlns:mv" => "urn:schemas-microsoft-com:mac:vml", "xmlns:o" => "urn:schemas-microsoft-com:office:office", "xmlns:r" => "http://schemas.openxmlformats.org/officeDocument/2006/relationships", "xmlns:m" => "http://schemas.openxmlformats.org/officeDocument/2006/math", "xmlns:v" => "urn:schemas-microsoft-com:vml", "xmlns:wp" => "http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing", "xmlns:w10" => "urn:schemas-microsoft-com:office:word", "xmlns:w" => "http://schemas.openxmlformats.org/wordprocessingml/2006/main", "xmlns:wne" => "http://schemas.microsoft.com/office/word/2006/wordml"}
    end

    # the following helpers effectively define a DSL for including page elements in a builder xml page
    # the 'new' method on each of the Doccex::PageElement objects returns a n xml string
    # representing the page element, which can be added to the page's xml representation
    #
    # Some of page elements also require an associated relationship in the word/_rels/document.xml.rels
    # file. The 'new' method also adds the required relationship, accessed by self.get_instance_variable(:@rels).
    def title(text)
      Doccex::PageElements::Title.new(self, text)
    end

    def heading1(text)
      Doccex::PageElements::Heading1.new(self, text)
    end

    def heading2(text)
      Doccex::PageElements::Heading2.new(self, text)
    end

    def section_properties(options = {})
      Doccex::PageElements::SectionProperties.new(self, options)
    end

    def single_tabbed_paragraph(options)
      Doccex::PageElements::SingleTabbedParagraph.new(self, options)
    end

    def table(options)
      Doccex::PageElements::Table.new(self, options)
    end

    def image(image_file)
      Doccex::PageElements::Image.new(self, image_file)
    end

    def cell(col, obj_name, obj)
      Doccex::PageElements::Cell.new(self, col, obj_name, obj)
    end

    def header_cell(string, col)
      Doccex::PageElements::HeaderCell.new(self, string, col)
    end
  end
end
