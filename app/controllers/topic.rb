Bbs::App.controllers :topic do

  before(:create, :update, :enjoy, :reply, :collection) do
    redirect "/session/new" unless signed_in?
  end

  post :create do
    content_type :json
    excute_block = lambda do |msg_json, code, message|
      title, body, node_id = params[:title].to_s, params[:body].to_s, params[:node_id].to_s
      raise BizErr, I18n.t('topic.title_is_null') if Validator.empty?(title)
      raise BizErr, I18n.t('topic.body_is_null') if Validator.empty?(body)
      raise BizErr, I18n.t('topic.node_id_is_null') if Validator.empty?(node_id)
      raise BizErr, I18n.t('topic.node_is_not_exist') unless Node[node_id]
      msg_json[:user] = session[:user_id]
      # Topic.create(:title => title, :body => body, :user_id => current_user.id, :node_id => node_id)
    end
    build_json(excute_block)
  end

  post :update do
    content_type :json
    excute_block = lambda do |msg_json, code, message|
      topic_id, title, body, node_id = params[:topic_id].to_s, params[:title].to_s, params[:body].to_s, params[:node_id].to_s
      raise BizErr, I18n.t('topic.topic_id_is_null') if Validator.empty?(topic_id)
      raise BizErr, I18n.t('topic.title_is_null') if Validator.empty?(title)
      raise BizErr, I18n.t('topic.body_is_null') if Validator.empty?(body)
      raise BizErr, I18n.t('topic.node_id_is_null') if Validator.empty?(node_id)
      raise BizErr, I18n.t('topic.node_is_not_exist') unless Node[node_id]
      raise BizErr, I18n.t('topic.topic_is_not_exist') unless topic = Topic[:id => topid_id, :user_id => current_user.id]
      topic.update(:title => title, :body => body, :node_id => node_id)
    end
    build_json(excute_block)
  end

  post :enjoy do
    content_type :json
    excute_block = lambda do |msg_json, code, message|
      topic_id = params[:topic_id].to_s
      raise BizErr, I18n.t('topic.topic_id_is_null') if Validator.empty?(topic_id)
      raise BizErr, I18n.t('topic.topic_is_not_exist') unless topic = Topic[topic_id]
      raise BizErr, I18n.t('topic.topic_is_enjoyed') if Enjoy[:topic_id => topic_id, :user_id => current_user.id]
      Enjoy.create(:user_id => current_user.id, :topic_id => topic_id)
      topic.update(:enjoy_count => topic.enjoy_count + 1)
    end
    build_json(excute_block)
  end

  post :collection do
    content_type :json
    excute_block = lambda do |msg_json, code, message|
      topic_id = params[:topic_id].to_s
      raise BizErr, I18n.t('topic.topic_id_is_null') if Validator.empty?(topic_id)
      raise BizErr, I18n.t('topic.topic_is_not_exist') unless topic = Topic[topic_id]
      raise BizErr, I18n.t('topic.topic_is_collection') if Collection[:topic_id => topic_id, :user_id => current_user.id]
      Collection.create(:user_id => current_user.id, :topic_id => topic_id)
      topic.update(:collection_count => topic.collection_count + 1)
    end
    build_json(excute_block)
  end

  post :reply do
    content_type :json
    excute_block = lambda do |msg_json, code, message|
      body, topic_id = params[:body].to_s, params[:topic_id].to_s
      raise BizErr, I18n.t('topic.reply_body_is_null') if Validator.empty?(body)
      raise BizErr, I18n.t('topic.topic_id_is_null') if Validator.empty?(topic_id)
      raise BizErr, I18n.t('topic.topic_is_not_exist') unless topic = Topic[topic_id]
      raise BizErr, I18n.t('topic.topic_is_collection') if Collection[:topic_id => topic_id, :user_id => current_user.id]
      Collection.create(:user_id => current_user.id, :topic_id => topic_id)
      topic.update(:reply_count => topic.reply_count + 1, :last_reply_at => Time.now)
    end
    build_json(excute_block)
  end

  get :list do
    content_type :json
    excute_block = lambda do |msg_json, code, message|
      msg_json[:topics] = Topic.search(params)
    end
    build_json(excute_block)
  end

  get :detail do
    content_type :json
    excute_block = lambda do |msg_json, code, message|
      topic_id = params[:topic_id].to_s
      raise BizErr, I18n.t('topic.topic_id_is_null') if Validator.empty?(topic_id)
      raise BizErr, I18n.t('topic.topic_is_not_exist') unless topic = Topic.find_by_id(topic_id)
      msg_json[:topic] = topic
      topic.update(:view_count => topic.view_count + 1)
    end
    build_json(excute_block)
  end

  get :replies do
    content_type :json
    excute_block = lambda do |msg_json, code, message|
      topic_id = params[:topic_id].to_s
      raise BizErr, I18n.t('topic.topic_id_is_null') if Validator.empty?(topic_id)
      msg_json[:replies] = Topic.get_replies(topic_id)
    end
    build_json(excute_block)
  end

  get :pop do
    content_type :json
    excute_block = lambda do |msg_json, code, message|
      msg_json[:pop_topics] = Topic.get_pop
    end
    build_json(excute_block)
  end

  get :test_redis do
    content_type :json
    excute_block = lambda do |msg_json, code, message|
      unless RedisCache.get('pop_topics')
        pop_topics = '1frajgkewjagjr'
        RedisCache.set('pop_topics', pop_topics)
        puts 'first'
      end
      msg_json[:pop_topics] = RedisCache.get('pop_topics')
    end
    build_json(excute_block)
  end

end