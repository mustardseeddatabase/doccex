xml.w :tr do
  xml.w :trPr do
    xml.w :cantSplit
    xml.w :trHeight, "w:val" => row[:height][:twips], "w:hRule" => row[:hRule]
  end
  cols.each do |col|
    xml << cell(col, obj_name, obj)
  end
end
