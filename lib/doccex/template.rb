require 'erb'

class Doccex::Template < Doccex::Base
  def initialize(template, view_assigns)
    view_assigns.keys.each do |key|
      instance_variable_set("@"+key, view_assigns[key])
    end
    create_template(template)
  end

  def create_template(template)
    FileUtils.cp_r(Rails.application.root.join("app", template), Rails.application.root.join('tmp'))
    temp = template.split("/")[1]
    FileUtils.mv("tmp/#{temp}","tmp/docx", :force => true)
  end

  def render_to_string
    source = Rails.application.root.join('tmp/docx')
    interpolate_variables
    zip_package(source)
    read_zipfile
  end

  def interpolate_variables
    source = Rails.application.root.join('tmp/docx/word/document.xml')
    template = ERB.new File.read(source)
    File.write(source, template.result(binding))
  end

end
