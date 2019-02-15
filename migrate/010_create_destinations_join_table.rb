Sequel.migration do
  change do
    create_table(:destinations) do
      foreign_key :airport_id, :airports
      foreign_key :destination_id, :airports
    end
  end
end
