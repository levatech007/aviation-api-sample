Sequel.migration do
  change do
    alter_table :airports do
      drop_column :destinations
    end
  end
end
