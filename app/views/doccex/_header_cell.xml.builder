xml.w :tc do
  xml.w :tcPr do
    xml.w :tcW,"w:w" => col[:twips],"w:type" => "dxa"
    xml.w :vAlign, "w:val" => col[:align]
  end
  xml << heading2(string)
end
