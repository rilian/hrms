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

  def active_class(path)
    'active' if (path == request.path)
  end

  def grade(mark)
    case mark
    when 5
      "5. Very good"
    when 4
      "4. Good"
    when 3
      "3. Middle"
    when 2
      "2. Bad"
    when 1
      "1. Very bad"
    else
      "Undefined"
    end
  end

  def with_newlines(str)
    str.gsub("\n", '<br/>').html_safe
  end
end
