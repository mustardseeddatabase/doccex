xml.w :p do
  xml.w :pPr do
    xml.w :tabs do
      xml.w :tab, "w:val" => tab[:val], "w:pos" => tab[:pos]
    end
  end
  xml.w :r do
    xml.w :t, contents[0]
  end
  xml.w :r do
    xml.w :tab
    xml.w :t, contents[1]
  end
end
