Bbs::App.controllers :user do 

  before :except => [:create] do
    puts params
    redirect "/session/new" unless signed_in?
  end

  get :info do
    content_type :json
    excute_block = lambda do |msg_json, code, message|
      msg_json[:user] = current_user.to_hash
    end
    build_json(excute_block)
  end

  post :create do
    content_type :json
    excute_block = lambda do |msg_json, code, message|
      email, password = params[:email].to_s, params[:password].to_s
      raise BizErr, I18n.t('user.email_is_null') if Validator.empty?(email)
      raise BizErr, I18n.t('user.password_is_null') if Validator.empty?(password)
      raise BizErr, I18n.t('user.email_not_validate') unless Validator.email?(email)
      raise BizErr, I18n.t('user.password_not_validate') unless Validator.password?(password)
      raise BizErr, I18n.t('user.user_is_exist') if User[:email => email]
      user = User.create(:email => email, :password => password)
      sign_in(user)
    end
    build_json(excute_block)
  end

  post :update do
    content_type :json
    excute_block = lambda do |msg_json, code, message|
      msg_json[:user] = session[:user_id]
    end
    build_json(excute_block)
  end

  post :change_password do
    content_type :json
    excute_block = lambda do |msg_json, code, message|
      new_pwd, old_pwd = params[:new_pwd], params[:old_pwd]
    end
    build_json(excute_block)
  end

  post :avatar do
    content_type :json
    excute_block = lambda do |msg_json, code, message|
      msg_json[:avatar_url] = ''
    end
    build_json(excute_block)
  end

  get :my_collection do
    content_type :json
    excute_block = lambda do |msg_json, code, message|
      msg_json[:collections] = current_user.collections(params)
    end
    build_json(excute_block)
  end

  get :my_topic do
    content_type :json
    excute_block = lambda do |msg_json, code, message|
      msg_json[:topics] = Topic.search({:user_id => current_user.id})
    end
    build_json(excute_block)
  end

  get :my_enjoy do
    content_type :json
    excute_block = lambda do |msg_json, code, message|
      msg_json[:enjoys] = current_user.enjoys(params)
    end
    build_json(excute_block)
  end

  get :my_reply do
    content_type :json
    excute_block = lambda do |msg_json, code, message|
      msg_json[:replies] = current_user.replies(params)
    end
    build_json(excute_block)
  end
  
end