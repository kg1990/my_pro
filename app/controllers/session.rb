Bbs::App.controllers :session do

  get :new do
    redirect url("/") if signed_in?
    'new'
    # render "/session/new", nil, :layout => false
  end

  post :create do
    if user = User.authenticate(params[:email], params[:password])
      sign_in(user)
      'ok'
      # redirect url("/")
    else
      # params[:email] = h(params[:email])
      # flash.now[:error] = ''
      # render "/session/new", nil, :layout => false
      'ng'
    end
  end

  delete :destroy do
    sign_out
    redirect url(:session, :new)
  end
  
end