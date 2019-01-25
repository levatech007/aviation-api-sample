require 'nokogiri'
require 'rest-client'

wiki_page = Nokogiri::HTML(RestClient.get("https://en.wikipedia.org/wiki/San_Francisco_International_Airport"))
table = wiki_page.css('table')[3]

rows = table.css('tr')
column_names = rows.shift.css('th').map(&:text)

text_all_rows = rows.map do |row|

  row_values = row.css('td').map(&:text)

  [*row_values]
end

text_all_rows.each do |row_as_text|
  column_names.zip(row_as_text).to_h
end
