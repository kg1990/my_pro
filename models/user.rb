class User < Sequel::Model

  attr_accessor :password

  def before_save
    self.name = self.email.split('@')[0]
    self.activate_code = SecureRandom.uuid.delete('-')
    encrypt_password
    now = Time.now
    self.created_at = now
    self.updated_at = now
  end

  def before_update
    self.updated_at = Time.now
  end

  ##
  # This method is for authentication purpose.
  #
  def self.authenticate(email, password)
    account = filter(Sequel.function(:lower, :email) => Sequel.function(:lower, email)).first
    account && account.has_password?(password) ? account : nil
  end

  ##
  # Replace ActiveRecord method.
  #
  def self.find_by_id(id)
    self[id] rescue nil
  end

  def has_password?(password)
    ::BCrypt::Password.new(self.crypted_password) == password
  end

  def to_hash
    {
      :name => self.name, 
      :email => self.email, 
      :sign => self.sign, 
      :avatar_url => self.avatar_url,
      :website => self.website,
      :state => self.state,
      :last_login_at => self.last_login_at
    }
  end

  def collections(params)
    page = params[:page].to_i > 0 ? params[:page].to_i : 1
    per_page = params[:per_page].to_i > 0 ? params[:page].to_i : 20
    options = []
    options << self.id
    sql = "select c.id, c.created_at, t.title, t.id, u.name from collections c 
      left join topics t on t.id = c.topic_id
      left join users u on u.id = t.user_id where c.user_id = ? order by c.created_at desc limit #{per_page} offset #{(page - 1) * per_page} "
    DB[sql, *options].all
  end

  def enjoys(params)
    page = params[:page].to_i > 0 ? params[:page].to_i : 1
    per_page = params[:per_page].to_i > 0 ? params[:page].to_i : 20
    options = []
    options << self.id
    sql = "select e.id, e.create_at, t.title, t.id, u.name from enjoys e
      left join topics t on t.id = e.topic_id
      left join users u on u.id = t.user_id where e.user_id = ? order by e.created_at desc limit #{per_page} offset #{(page - 1) * per_page} "
    DB[sql, *options].all
  end

  def enjoys(params)
    page = params[:page].to_i > 0 ? params[:page].to_i : 1
    per_page = params[:per_page].to_i > 0 ? params[:page].to_i : 20
    options = []
    options << self.id
    sql = "select r.id, r.create_at, r.body, t.title, t.id, u.name from replies r
      left join topics t on t.id = r.topic_id
      left join users u on u.id = t.user_id where r.user_id = ? order by r.created_at desc limit #{per_page} offset #{(page - 1) * per_page}"
    DB[sql, *options].all
  end

  private

  def encrypt_password
    self.crypted_password = ::BCrypt::Password.create(password) if password.present?
  end

  def password_required
    self.crypted_password.blank? || password.present?
  end

end
