# Doccex

Very lightweight Rails engine to produce MSWord documents from a Rails application. Uses the xml file structure that constitutes a .docx file. (If you're not familiar with this, change the extension of a .docx file to .zip and unzip it).

# How it works

Doccex implements two alternative strategies for generating MSWord documents. There is a simple template-based strategy with limited flexibility, and a more complicated document build ("builder") strategy that has much more flexibility.

If you can live with the template-based strategy, your life will be much easier! You need to use the builder strategy if you need to generate a rels file representing the contents of your document. This is necessary when:

  * Your document has multiple sections with different column counts in each.

  * Your document includes images.

  * Your document has multiple sections with different footers.

## The template approach

A single xml file, document.xml, is used as a template for the document. All other files in the collection of files that comprise a .docx file are untouched, just copied from the Doccex template.

The document.xml file may contain erb tags for the interpolation of Ruby variables, or for the inclusion of Ruby code (typically iterators for repeated elements).

The easiest approach to constructing a template is to start with an MSWord document, unzip it (change its extension to .zip and unzip it), and use the resulting document.xml document as a starting point.

You will find that MSWord sometimes pulls apart strings into separate text elements. Mostly this is unneccessary and you will want to recombine them so that your variables are properly rendered.

I have found it helpful to actually insert erb tags and ruby variables into the MSWord document, and then go hunt for these tags and variables in the resulting document.xml file. Word will translate the erb tags to &lt;%= and =&gt;, you need to convert these back to properly formatted erb.

It is most definitely outside the scope here to provide a guide on the structure of the document.xml document, but the main points are:

  * Text elements are defined by a nested set of paragraph (`<w:p>`), run (`<w:r>`) and text (`<w:t>`) xml tags.

  * Tables are structures similar to html tables with a nested set of table (`<w:tbl>`), row (`<w:tr>`) and cell (`<w:tc>`) xml tags.

## The builder approach

When a document includes certain elements or features, the document.xml file is not the only one that must be generated. A "rels" or relationships file must also be generated that carries identification information about the elements in the document.xml file, and also links elements to image files and other files.

In this approach, the document.xml file is built using the Builder gem. Consult this gem's documentation for the syntax.

View helpers are included that build page elements by rendering builder partials to strings that are incorporated in the document.xml file.

### Adding a new page element

The first release of Doccex includes the following page elements:

  * table, header row, table cell
  * level 1 heading
  * level 2 heading
  * footer
  * image
  * section properties
  * paragraph

If you wish to add a new page element object. Do the following:

  1. Add a view helper in app/helpers/doccex_helper.rb. The helpers in lib/doccex/page_elements are available in the host Rails applications views to render page elements.

  2. Define the class in a new file, included in lib/doccex/page_elements/. The class should inherit from String and instantiating the class should produce an xml string for inclusion in the page builder buffer.

  3. Include any partials that might be needed for the new class in app/views/doccex.

You can study the existing page elements to see how these three components interrelate.

## Rendering a document from the controller

A document might typically be rendered from a #show method in a controller.

### Using the template approach

    def  show
      @inventory_value = Item.all.map(&:cost).sum
      @cash_balance = Accounts.map(&:balance).sum
      @date = Date.today
      @net_change = Accounts.each{|a| a.transactions.in_month(@date).sum}.sum

      respond_to do |format|
        format.docx do
          render :docx => 'monthly_accounting_report',
                 :template => "/" + Rails.root.join("app/document_templates/my_report"),
                 :from_template => true
        end
      end
    end

Here 'monthly_accounting_report' is the name that will be assigned in the browser when the report is downloaded.

The :template value is the directory in which the template MSWord dcument filesystem is to be found. The easiest way to create this is from an MSWord document, which is then unzipped.

The :from_template value signals to Doccex that it should look for the the document.xml file in the template files, interpolate variables in erb tags, zip the filesystem, and send the result to the browser.

### Using the builder approach

Render the default template:

    def show
      @categorized_items = Item.sort_by(&:description).group_by(&:category)

      respond_to do |format|
        format.html
        format.docx { render :docx => "sku_list"} # renders show.docx.builder
      end
    end

Above, because no template is specified, Rails looks for one with the same name as the action.

    def show
      @categorized_items = Item.sort_by(&:description).group_by(&:category)

      respond_to do |format|
        format.html
        format.docx do
          render :docx => "sku_list_barcodes",
                 :template => "sku_lists/sku_list_barcodes",
                 :formats => [:xml], :handlers => [:builder]
        end
      end
    end

In this case, a template other than the default is specified, the filename would be sku_lists/sku_list_barcodes.xml.builder.

### Builder templates

The Builder gem, at http://builder.rubyforge.org/, has good documentation.

A builder file is pure Ruby. Here is an annotated example:

    xml.instruct! :xml, :standalone => 'yes'

    xml.w :document, document_namespaces do # document_namespaces helper comes from the Doccex engine
      xml.w :body do

        xml << heading1("SKU List Barcodes")
        footer = Footer.new(render :partial => 'footer', :formats => [:xml])
        xml << section_properties(:include_footer => true)

        @categorized_items.sort.each do |category,items|
          xml << heading2(category)
          xml << section_properties # section properties are defined _after_ the section to which they pertain. Here we define a single column (default)
          xml << table( :collection => items,
                        :obj_name => :item,
                        :header_row => ["category", "count"],
                        :row => {:height => {:twips => 432}, :hRule => 'exact'}, # about 0.3" height
                        :cols => [ {:align => 'center', :twips => 2886, :cell_contents => 'sku_lists/cell1_contents.xml'},
                                   {:align => 'right', :twips => 3456, :cell_contents => 'sku_lists/cell2_contents.xml'}])
          xml << section_properties(:num_cols => 2) # the preceding tables are arranged in two columns
        end


        # the following paragraph and section properties seems to be necessary in order
        # for MSWord not to append a spurious page
        xml.w :p do
          xml.w :pPr
        end
        xml.w :sectPr do
          xml.w :type, "w:val" => "continuous"
          xml.w :pgSz, "w:w" => "15840", "w:h" => "12240", "w:orient" => "landscape"
          xml.w :pgMar, "w:top" => "990", "w:right" => "1440", "w:bottom" => "1080", "w:left" => "1440", "w:header" => "708", "w:footer" => "708", "w:gutter" => "0"
          xml.w :cols, "w:space" => "708"
        end
      end
    end

The helpers are located in app/helpers/doccex/doccex_helper.rb. See the documentation for each of the helpers in lib/doccex/page_elements for descriptions of the arguments.

Cell contents are defined in .xml.builder files in the host application. The following are two examples:

When the cell has string contents (note the nexted paragraph/run/text structure):

    xml.w :p do
      xml.w :r do
        xml.w :t, "#{item.description} (#{item.weight_oz} oz)"
      end
    end

When the cell contains an image. Here a Doccex image helper is passed the location of an image file. At the same time, a method in the host application has been instructed to place the image inside the media directory of the file structure of the document being prepared.

    xml << image(item.create_barcode_image("tmp/docx/word/media/image#{item.sku}.png"))


## License

MIT-LICENSE
