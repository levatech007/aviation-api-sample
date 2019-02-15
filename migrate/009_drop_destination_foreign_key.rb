Sequel.migration do
  change do
    alter_table :airports do
      drop_foreign_key :destination_airport_id
    end
  end
end
