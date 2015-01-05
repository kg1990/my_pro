Sequel.migration do
  up do
    create_table :nodes do
      primary_key :id
      String :name, :size => 255, :null => false
      Integer :sort_index, :default => 0, :null => false
      Time :created_at, :null => false
      Time :updated_at, :null => false
      index [:name], :unique => true
    end
  end

  down do
    drop_table :nodes
  end
end
