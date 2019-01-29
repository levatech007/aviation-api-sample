Sequel.migration do
  change do
    add_column :airports, :destinations, String
  end
end
