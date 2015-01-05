Bbs::App.controllers :node do

  get :list do
    content_type :json
    excute_block = lambda do |msg_json, code, message|
      msg_json[:nodes] = Node.get_list
    end
    build_json(excute_block)
  end

end