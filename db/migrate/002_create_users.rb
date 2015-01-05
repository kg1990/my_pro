Sequel.migration do
  up do
    create_table :users do
      primary_key :id
      String :name, :null => false, :size => 255
      String :email, :null => false, :size => 255
      String :crypted_password, :null => false, :size => 255
      #qianming
      String :sign, :size => 255
      String :avatar_url
      String :website, :size => 255
      #0 -> unactive 1 -> active 2 -> lock
      Integer :state, :null => false, :default => 0
      String :activate_code, :size => 255
      Time :last_login_at
      Time :created_at, :null => false
      Time :updated_at, :null => false
      index [:email], :unique => true
    end
  end

  down do
    drop_table :users
  end
end
