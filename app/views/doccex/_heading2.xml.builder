xml.w :p do
  xml.w :pPr do
    xml.w :pStyle, "w:val" => "Heading2"
  end
  xml.w :r do
    xml.w :t, text
  end
end
