Sequel.migration do
  up do
    create_table :topics do
      primary_key :id
      Integer :user_id, :null => false
      Integer :node_id, :null => false
      String :title, :size => 255, :null => false
      String :body, :text => true, :null => false
      Integer :view_count, :default => 0
      Integer :reply_count, :default => 0
      Integer :enjoy_count, :default => 0
      Time :created_at, :null => false
      Time :updated_at, :null => false
      Time :last_reply_at
    end
  end

  down do
    drop_table :topics
  end
end
