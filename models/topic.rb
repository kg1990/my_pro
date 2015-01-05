class Topic < Sequel::Model

  def before_save
    now = Time.now
    self.created_at = now
    self.updated_at = now
  end

  def before_update
    self.updated_at = Time.now
  end

  def self.search(params)
    page = params[:page].to_i > 0 ? params[:page].to_i : 1
    per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : 20
    title = params[:title].to_s.strip
    user_id = params[:user_id].to_s.strip
    user_name = params[:user_name].to_s.strip
    order = params[:order].to_s.strip
    sort = params[:sort].to_s.strip
    options = []
    sql = "select t.*, u.name, u.email, u.sign, u.website 
      from topics t left join users u on u.id = t.user_id where 1=1 "
    if title != ''
      sql = sql + ' and t.title like %?% '
      options << title
    end
    if user_name != ''
      sql = sql + ' and u.name like %?% '
      options << user_name
    end
    if user_id != ''
      sql = sql + ' and u.id = ? '
      options << user_id
    end
    if ['created_at, update_at, collection_count, view_count, reply_count, last_reply_at'].include?(order)
      if ['desc', 'asc'].include?(sort)
        sql = sql + " order by t.#{order} #{sort}"
      else
        sql = sql + " order by t.#{order} desc"
      end
    else
      sql = sql + " order by t.created_at desc"
    end
    sql = sql + " limit #{per_page} offset #{(page - 1) * per_page}"
    DB[sql, *options].all
  end

  def self.pop_list
    sql = "selet top 10 from topics order by reply_count desc" 
    DB[sql].all
  end

  def self.find_by_id(id)
    Topic[id] rescue nil
  end

  def self.get_replies(id)
    Reply.where(:topic_id => id)
  end

end
