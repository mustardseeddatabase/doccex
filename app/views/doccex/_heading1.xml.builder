xml.w :p do
  xml.w :pPr do
    xml.w :pStyle, "w:val" => "Heading1"
    xml.w :spacing, "w:before" => "0", "w:after" => "480"
  end
  xml.w :r do
    xml.w :t, text
  end
end
