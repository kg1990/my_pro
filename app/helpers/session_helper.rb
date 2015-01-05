Bbs::App.helpers do

  def sign_in(user)
    session[:user_id] = user.id.to_s
  end

  def sign_out
    session.delete(:user_id)
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user
    @current_user ||= signin_from_cookie_or_session
  end

  def signin_from_cookie_or_session
    user = User.find_by_id(session[:user_id].to_s.to_i) rescue nil
    return user unless user.nil?
    nil
  end

end