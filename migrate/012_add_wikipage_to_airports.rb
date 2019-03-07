Sequel.migration do
  change do
    add_column :airports, :airport_wiki_page, String
  end
end
