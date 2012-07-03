xml.w :tr do
  xml.w :trPr do
    xml.w :cantSplit
    xml.w :trHeight, "w:val" => 600, "w:hRule" => 'exact'
  end
  array.each do |string|
    index = array.index(string)
    col = cols[index]
    xml << header_cell(string, col)
  end
end
