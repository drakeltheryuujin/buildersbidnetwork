module ProjectDocumentsHelper
  def doc_icon_path(project_document)
    result = "/images/doc_icons/"
    case project_document.asset_content_type
      when /^application\/pdf$/, /^application\/x-pdf$/, /^application\/acrobat$/, /^applications\/vnd.pdf$/, /^text\/pdf$/, /^text\/x-pdf$/
        result += "pdf.png"
      when /^application\/zip$/
        result += "zip.png"
      when /^application\/vnd.ms-excel$/, /^application\/msexcel$/, /^application\/x-msexcel$/, /^application\/x-ms-excel$/, /^application\/vnd.ms-excel$/, /^application\/x-excel$/, /^application\/x-dos_ms_excel$/, /^application\/xls$/ 
        result += "xls.png"
      when /^application\/vnd.ms-powerpoint$/, /^application\/mspowerpoint$/, /^application\/ms-powerpoint$/, /^application\/mspowerpnt$/, /^application\/vnd-mspowerpoint$/, /^application\/powerpoint$/, /^application\/x-powerpoint$/
        result += "ppt.png"
      when /^application\/postscript$/, /^application\/eps$/, /^application\/x-eps$/
        result += "eps.png"
      else
        result += "doc.png"
    end
  end
end
