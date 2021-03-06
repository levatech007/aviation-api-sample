Sequel.migration do
  change do
    create_table(:apikeys) do
      primary_key :id, unique: true
      String :api_key
      Integer :api_rpd # requests per day
    end
  end
end
