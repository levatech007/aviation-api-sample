# get IATA codes
class ScrapeIataCodes
  require 'nokogiri'
  require 'rest-client'

  # https://en.wikipedia.org/wiki/List_of_airports_by_IATA_code:_A (pages organized by alphabet).
  # page existst for each letter of the english alphabet
  BASE_URL = 'https://en.wikipedia.org/wiki/List_of_airports_by_IATA_code:_'

  def scrape_iata_codes
    alphabet = ('A'..'Z').to_a
    airport_data = []

    alphabet.each do |letter|
      url = BASE_URL + letter
      html = RestClient.get(url)
      wiki_page = Nokogiri::HTML(html)
      table = wiki_page.css('table')[0]

      table.search('tr').each do |tr|
        table_data = tr.search('td')
        if(!table_data[0].nil? && !table_data[1].nil? && !table_data[2].nil?)
          if(!table_data[1].children.text.nil?) # table_data[1] is ICAO code; only process <tr> elements that have ICAO code
            airport_data.push(
              {
                airport_iata_code: table_data[0].children.text,
                airport_icao_code: table_data[1].children.text,
                airport_wiki_page: table_data[2].at('a')['href']
              }
            )
          end
        end
      end
    end

    return airport_data
  end


end
