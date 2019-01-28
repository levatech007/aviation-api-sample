require 'nokogiri'
require 'rest-client'
lax_url = "https://en.wikipedia.org/wiki/Los_Angeles_International_Airport"
lax_table_number = 4
sfo_url = "https://en.wikipedia.org/wiki/San_Francisco_International_Airport"
sfo_table_number = 3
sxm_url = "https://en.wikipedia.org/wiki/Princess_Juliana_International_Airport"
sxm_table_number = 2
wiki_page = Nokogiri::HTML(RestClient.get(sxm_url))
table = wiki_page.css('table')[sxm_table_number] #replace idx with table number

rows = table.css('tr')
column_names = rows.shift.css('th').map(&:text)

text_all_rows = rows.map do |row|
  row_values = row.css('td').map(&:text)
  [*row_values]
end

text_all_rows.each do |row_as_text|
  p column_names.zip(row_as_text).to_h
end
