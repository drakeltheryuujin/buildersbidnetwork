module DeviseHelper
  def devise_error_messages! 
    error_for_res(resource)
  end 


  def error_for_res(res)
    return "" if res.errors.empty? 

#messages = res.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    messages = res.errors.full_messages.map { |msg| "<li>#{msg}</li>" }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => res.errors.count,
                      :res => res.class.model_name.human.downcase,
                      :resource => res.class.model_name.human.downcase)

    html = <<-HTML
      <div class="alert-message block-message error">
        <strong>#{sentence}</strong>
        <ul>#{messages}</ul>
      </div>
    HTML

    html.html_safe
  end
end
