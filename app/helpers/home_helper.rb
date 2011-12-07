module HomeHelper
  def put_if_current_page(output, path)
    current_page?(path) ? output : ''
  end
end
