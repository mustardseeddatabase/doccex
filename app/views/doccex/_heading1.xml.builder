xml.w :p do
  xml.w :pPr do
    xml.w :pStyle, "w:val" => "Heading1"
    xml.w :spacing, "w:before" => "480", "w:after" => "160"
  end
  xml.w :r do
    xml.w :t, text
  end
end
