Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id, unique: true
      String :api_key, null: false
      Integer :api_rpd, null: false
    end
  end
end
