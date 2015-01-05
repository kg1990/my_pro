class Node < Sequel::Model

  def before_save
    now = Time.now
    self.created_at = now
    self.updated_at = now
  end

  def before_update
    self.updated_at = Time.now
  end

  def self.get_list
    DB["select id, name, sort_index from nodes order by sort_index desc"].all
  end

end
