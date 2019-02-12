Sequel.migration do
  change do
    alter_table :airports do
      add_foreign_key :destination_airport_id, :airports
    end 
  end
end
