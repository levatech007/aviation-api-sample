Sequel.migration do
  change do
    add_column :airports, :airport_city, String
  end
end
