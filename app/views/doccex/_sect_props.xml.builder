xml.w :p do
  xml.w :pPr do
    xml.w :sectPr do
      (xml.w :footerReference, "w:type" => "default", "r:id" => footerReference) if defined? footerReference # if provided it should be of form "rIdn"
      xml.w :type, "w:val" => "continuous"
      xml.w :pgSz, "w:w" => "15840", "w:h" => "12240", "w:orient" => "landscape"
      xml.w :pgMar, "w:top" => "990", "w:right" => "1440", "w:bottom" => "1080", "w:left" => "1440", "w:header" => "708", "w:footer" => "708", "w:gutter" => "0"
      if defined? num_cols
        xml.w :cols, "w:num" => num_cols.to_s, "w:space" => "708"
      else
        xml.w :cols, "w:space" => "708"
      end
      xml.w :printerSettings, "r:id" => rId
    end
  end
end
