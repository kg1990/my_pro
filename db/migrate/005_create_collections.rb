Sequel.migration do
  up do
    create_table :collections do
      primary_key :id
      Integer :user_id, :null => false
      Integer :topic_id, :null => false
      Time :created_at, :null => false
      Time :updated_at, :null => false
    end
  end

  down do
    drop_table :collections
  end
end
