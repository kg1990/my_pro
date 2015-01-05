class Collection < Sequel::Model

  def before_save
    now = Time.now
    self.created_at = now
    self.updated_at = now
  end

  def before_update
    self.updated_at = Time.now
  end

end
