xml.w :p do
  xml.w :pPr do
    xml.w :pStyle, "w:val" => "Title"
    xml.w :spacing, "w:before" => "0", "w:after" => "480"
  end
  fragments = text.split("\r")
  xml.w :r do
    xml.w :t, fragments.shift
  end

  fragments.each do |fragment|
    xml.w :r do
      xml.w :br
      xml.w :t, fragment
    end
  end
end
