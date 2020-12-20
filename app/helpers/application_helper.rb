module ApplicationHelper
  def flash_class(level)
    case level
    when 'notice' then 'alert alert-info'
    when 'success' then 'alert alert-success'
    when 'error' then 'alert alert-danger'
    when 'alert' then 'alert alert-warning'
    else ''
    end
  end

  def directory_size(path)
    size = 0
    Dir.glob(File.join(path, '**', '*')) { |file| size += File.size(file) }
    number_to_human_size size
  end

  def active_class(path, exclude_str: nil)
    return '' if exclude_str && request.fullpath.include?(exclude_str.to_s)
    'active' if URI.decode(request.fullpath).starts_with?(path)
  end

  def with_newlines(str)
    str.gsub("\n", '<br/>').html_safe.gsub(URI.regexp(%w(http https)), '<a href="\0">\0</a>').html_safe
  end

  def limit
    (params[:limit] || ENV['ITEMS_PER_PAGE']).to_i
  end

  def last_page?(collection)
    offset = params[:offset].to_i || 0
    (limit + offset) >= collection.limit(nil).offset(nil).size
  end

  def employees_path
    '/people?page[limit]=10000&page[offset]=0&q[sorts][]=status&q[sorts][]=name&q[status_in][]=Hired&q[status_in][]=Past+employee'
  end

  def flash_messages
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, id: 'flash', class: "alert alert-#{bootstrap_class_for(msg_type)} alert-dismissible text-center", role: 'alert') do
        concat(content_tag(:button, class: 'close', data: { dismiss: 'alert' }) do
          concat content_tag(:span, '&times;'.html_safe, 'aria-hidden' => true)
          concat content_tag(:span, 'Close', class: 'sr-only')
        end)
        concat message
      end)
    end
    nil
  end

  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type] || flash_type.to_s
  end
end
