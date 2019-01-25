require 'nokogiri'
require 'rest-client'

wiki_page = Nokogiri::HTML(RestClient.get("https://en.wikipedia.org/wiki/San_Francisco_International_Airport"))
# select <table> <tbody> then get text from each <tr>
destinations =  wiki_page.css('table')[3].css('tbody').children
list = []

destinations.each do |entry|
  list << {content: entry.children.to_html}
end




puts list
