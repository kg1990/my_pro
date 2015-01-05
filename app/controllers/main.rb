Bbs::App.controller do

  get "/" do
    @user = current_user.to_hash rescue nil
    render '/main/index', :layout => nil
  end

end