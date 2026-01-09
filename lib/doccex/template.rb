require 'erb'

class Doccex::Template < Doccex::Base
  attr_accessor :tmp_dir, :media_dir, :rels_file, :last_index

  def initialize(template, view_assigns, tmp_dir:)
    view_assigns.each_key do |key|
      instance_variable_set("@#{key}", view_assigns[key])
    end
    @tmp_dir = tmp_dir
    @media_dir = tmp_dir.join('docx', 'word', 'media')
    @rels = Doccex::Rels.new(tmp_dir: @tmp_dir)
    @rels_file = tmp_dir.join('docx', 'word', '_rels', 'document.xml.rels')
    @rids = []
    create_template(template)
    create_rels
    # @images is a hash: {household_id: instance_of_Signature, ...} images from the database associated with a line item
    create_image_rels if @images
    create_report_images if @report_images
    @rels.create_file
  end

  def create_rels
    extra_components = %w[styles settings webSettings footnotes endnotes header1 footer1 fontTable]
    extra_components.each do |filename|
      rel_type = filename.match(/\D+/)[0].to_sym # e.g. :header from "header1"
      @rels.create_relationship(rel_type) if File.exist?(tmp_dir.join('docx', 'word',
                                                                      "#{filename}.xml"))
    end
    @rels.create_relationship(:theme) if File.exist?(tmp_dir.join('docx', 'word', 'theme', 'theme1.xml'))
    @rels.create_relationship(:customXML) if File.exist?(tmp_dir.join('docx', 'word', 'ink', 'ink1.xml'))
  end

  def create_image_rels
    @images.each_value do |img|
      File.open(@media_dir.join(img.filename), 'wb') do |file|
        file.write img.image_data
      end
      @rids.push(@rels.next_id(:image, @media_dir.join(img.filename))) # returns the rId value e.g. 'rId7'
    end
  end

  def create_report_images
    @report_images.each do |img|
      @rids.push(@rels.next_id(:image, @media_dir.join(img))) # returns the rId value e.g. 'rId7'
    end
  end

  def create_template(template)
    src = Pathname(template).absolute? ? template : Rails.application.root.join('app', template)
    FileUtils.cp_r(src, tmp_dir)
    temp = template.split('/')[-1]
    FileUtils.rm_r(tmp_dir.join('docx')) if File.exist?(tmp_dir.join('docx'))
    FileUtils.mv(tmp_dir.join("#{temp}"), tmp_dir.join('docx'), force: true)
  end

  def render_to_string
    source = tmp_dir.join('docx')
    interpolate_variables
    zip_package(source)
    read_zipfile
  end

  def interpolate_variables
    %w[document header1].each { |e| interpolate_partial(e) }
  end

  private

  def interpolate_partial(name)
    source = tmp_dir.join("docx/word/#{name}.xml")
    return unless File.exist?(source)

    template = ERB.new File.read(source)
    File.write(source, template.result(binding))
  end
end
