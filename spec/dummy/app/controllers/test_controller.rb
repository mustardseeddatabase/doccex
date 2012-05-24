class TestController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.docx { render :docx => "test_doc" }
    end
  end
end
