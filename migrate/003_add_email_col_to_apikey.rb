Sequel.migration do
  change do
    add_column :apikeys, :email, String
  end
end
