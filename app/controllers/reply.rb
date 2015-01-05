Bbs::App.controllers :reply do

  post :destroy do
    content_type :json
    excute_block = lambda do |msg_json, code, message|
      
    end
    build_json(excute_block)
  end

  get :my_reply do
    content_type :json
    excute_block = lambda do |msg_json, code, message|
      
    end
    build_json(excute_block)
  end

end