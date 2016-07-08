module EventsHelper
  def cleanup_event_params(params)
    params
      .reject {|k,_| k.in? %w[created_at updated_at encrypted_password reset_password_token file_id] }
      .to_s
      .gsub('=>[nil, ', '=>[')
      .chomp('}')
      .reverse
      .chomp('{')
      .reverse
      .gsub('["", ', '[')
      .gsub('\r\n', ' '.html_safe)
  end
end
