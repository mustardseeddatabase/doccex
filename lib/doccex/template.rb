require 'erb'

class Doccex::Template < Doccex::Base
  attr_accessor :tmp_dir
  def initialize(template, view_assigns, tmp_dir:)
    view_assigns.keys.each do |key|
      instance_variable_set("@"+key, view_assigns[key])
    end
    @tmp_dir = tmp_dir
    create_template(template)
  end

  def create_template(template)
    src = Pathname(template).absolute? ? template : Rails.application.root.join("app", template)
    FileUtils.cp_r(src , tmp_dir)
    temp = template.split("/")[-1]
    FileUtils.rm_r(tmp_dir.join("docx")) if File.exists?(tmp_dir.join("docx"))
    FileUtils.mv(tmp_dir.join("#{temp}"),tmp_dir.join("docx"), :force => true)
  end

  def render_to_string
    source = tmp_dir.join('docx')
    interpolate_variables
    zip_package(source)
    debugger
    read_zipfile
  end

  def interpolate_variables
    ['document', 'header1'].each { |e| interpolate_partial(e)}
  end

  private
  def interpolate_partial(name)
    source = tmp_dir.join("docx/word/#{name}.xml")
    if File.exists?(source)
      template = ERB.new File.read(source)
      File.write(source, template.result(binding))
    end
  end

end
