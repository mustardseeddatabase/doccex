xml.w :sectPr do
  xml.w :type, "w:val" => "continuous"
  xml.w :pgSz, "w:w" => "15840", "w:h" => "12240", "w:orient" => "landscape"
  xml.w :pgMar, "w:top" => "1800", "w:right" => "1440", "w:bottom" => "1800", "w:left" => "1440", "w:header" => "708", "w:footer" => "708", "w:gutter" => "0"
  xml.w :cols, "w:num" => "4", "w:space" => "288"
  xml.w :printerSettings, "r:id" => rId
end
