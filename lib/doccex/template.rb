require 'erb'

class Doccex::Template < Doccex::Base
  def initialize(template, view_assigns)
    view_assigns.keys.each do |key|
      instance_variable_set("@"+key, view_assigns[key])
    end
    create_template(template)
  end

  def create_template(template)
    src = Pathname(template).absolute? ? template : Rails.application.root.join("app", template)
    FileUtils.cp_r(src , Rails.application.root.join('tmp'))
    temp = template.split("/")[-1]
    FileUtils.rm_r("tmp/docx") if File.exists?("tmp/docx")
    FileUtils.mv("tmp/#{temp}","tmp/docx", :force => true)
  end

  def render_to_string
    source = Rails.application.root.join('tmp/docx')
    interpolate_variables
    zip_package(source)
    read_zipfile
  end

  def interpolate_variables
    ['document', 'header1'].each { |e| interpolate_partial(e)}
  end

  private
  def interpolate_partial(name)
    source = Rails.application.root.join("tmp/docx/word/#{name}.xml")
    if File.exists?(source)
      template = ERB.new File.read(source)
      File.write(source, template.result(binding))
    end
  end

end
