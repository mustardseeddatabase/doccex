xml.w :p do
  xml.w :r do
    xml.w :rPr do
      xml.w :noProof
    end
    xml.w :drawing do
      xml.wp :inline, "distT" => "0", "distB" => "0", "distL" => "0", "distR" => "0" do
        xml.wp :extent, "cx" => "1270000", "cy" => "228600"
        xml.wp :effectExtent, "l" => "0", "t" => "0", "r" => "0", "b" => "0"
        xml.wp :docPr, "id" => index, "name" => "Picture #{index}"
        xml.wp :cNvGraphicFramePr do
          xml.a :graphicFrameLocks, "xmlns:a" => "http://schemas.openxmlformats.org/drawingml/2006/main", "noChangeAspect" => "1"
        end
        xml.a :graphic, "xmlns:a" => "http://schemas.openxmlformats.org/drawingml/2006/main" do
          xml.a :graphicData, "uri" => "http://schemas.openxmlformats.org/drawingml/2006/picture" do
            xml.pic :pic, "xmlns:pic" => "http://schemas.openxmlformats.org/drawingml/2006/picture" do
              xml.pic :nvPicPr do
                xml.pic :cNvPr, "id" => "0", "name" => "Picture 2"
                xml.pic :cNvPicPr do
                  xml.a :picLocks, "noChangeAspect" => "1", "noChangeArrowheads" => "1"
                end
              end
              xml.pic :blipFill do
                xml.a :blip, "r:embed" => rid do
                  xml.a :extLst do
                    xml.a :ext, "uri" => "{28A0092B-C50C-407E-A947-70E740481C1C}" do
                      xml.a14 :useLocalDpi, "xmlns:a14" => "http://schemas.microsoft.com/office/drawing/2010/main", "val" => "0"
                    end
                  end
                end
                xml.a :srcRect
                xml.a :stretch do
                  xml.a :fillRect
                end
              end
              xml.pic :spPr, "bwMode" => "auto" do
                xml.a :xfrm do
                  xml.a :off, "x" => "0", "y" => "0"
                  xml.a :ext, "cx" => "1270000", "cy" => "228600"
                end
                xml.a :prstGeom, "prst" => "rect" do
                  xml.a :avLst
                end
                xml.a :noFill
                xml.a :ln do
                  xml.a :noFill
                end
              end
            end
          end
        end
      end
    end
  end
end
