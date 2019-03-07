# in the future, scrape all airport destinations from here
require 'nokogiri'
require 'rest-client'
# https://en.wikipedia.org/wiki/List_of_airports_by_IATA_code:_A (pages organized bu alphabet)
BASE_URL = 'https://en.wikipedia.org/wiki/List_of_airports_by_IATA_code:_A'
alphabet = ['A'..'Z'].to_a
#alphabet.each do |letter| end
html = RestClient.get(BASE_URL)
wiki_page = Nokogiri::HTML(html)
airport_data = []
table = wiki_page.css('table')[0]

table.search('tr').each do |tr|
  p("Row is #{ tr }")
  table_data = tr.search('td')
  if(!table_data[0].nil? && !table_data[1].nil? && !table_data[2].nil?)
    airport_data.push(
      {
        airport_iata_code: table_data[0].children.text,
        airport_icao_code: table_data[1].children.text,
        airport_wiki_page: table_data[2].at('a')['href']
      }
    )
    end
  p(airport_data)
  return airport_data
end
