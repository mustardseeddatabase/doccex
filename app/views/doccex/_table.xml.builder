xml.w :tbl do
  xml.w :tblPr do
    xml.w :tblStyle, "w:val" => style
    xml.w :tblW, "w:w" =>"0", "w:type" =>"auto"
    xml.w :tblLook, "w:val" =>"04A0", "w:firstRow" =>"1", "w:lastRow" =>"0", "w:firstColumn" =>"1", "w:lastColumn" =>"0", "w:noHBand" =>"0", "w:noVBand" =>"1"
  end
  xml.w :tblGrid do
    cols.each do |col|
      xml.w :gridcol, "w:w" => col[:twips].to_s
    end
  end

  xml << rows
end
