# scrape airport destinations
#class ScrapeAirportDestinations
  require 'nokogiri'
  require 'rest-client'

  # BASE_URL = "https://en.wikipedia.org"

  # def initialize(airport_wiki_page)
  #   @airport_wiki_page = airport_wiki_page
  # end

  #def scrape_destinations

    example_url = "https://en.wikipedia.org/wiki/Narita_International_Airport"
    # url = "#{ BASE_URL }#{ @airport_wiki_page }"
    html = RestClient.get(example_url)
    # html = RestClient.get(BASE_URL)
    wiki_page = Nokogiri::HTML(html)
    tables    = wiki_page.css('table')
    result = {}
    airlines_destinations_table_found = false

    tables.each do |table|
      rows     = table.css('tr')
      row_name = rows.css('th').text

      if !airlines_destinations_table_found
        if row_name == 'AirlinesDestinationsRefs' || row_name == 'AirlinesDestinations'  # => there is no unique id for table, find it by <th> value "AirlinesDestinationsRefs", contains necessary data
          airlines_destinations_table_found = true # destinations table name 'AirlinesDestinations' applies to passenger and cargo tables. First is always passenger traffic
          all_destination_row_text  = rows.map { |row| row.css('td').map(&:text) }
          all_destination_row_links = rows.map { |row| row.css('td a').map { |link| link['href'] } }

          all_destinations = []
          all_destination_row_text.map do |row|
            all_destinations.push(row[1].gsub(/\s+/, "")) if !row.empty? # row[1] is destinations column, remove all whitespace
          end

          all_wiki_links = []
          all_destination_row_links.map { |row| all_wiki_links.push(row[1...-1]) } # take all values except first (airline link)

          result = {
                      all_destinations: all_destinations,
                      wiki_pages: all_wiki_links
                   }
        end
      end
    end
    #return result
    p(result)

    # def format_destinations(data_array)
    #   regular_destinations = []
    #   seasonal_destinations = []
    #   # for each destinations array:
    #   # split to individual destinations
    #   # remove refs ex. [123]
    #   # remove destinations with (begins...) (resumes...) for now
    #   # keep destination
    #   # remove destinations with (begins ...) or (resumes ...) => future destinations need to be stored separately?
    #   # return hash { regular_destinations: [], seasonal_destinations: [] }
    # end
    #
    # def format_wiki_links(links)
    #   # links is array of arrays
    #   # remove nil or []
    #   #
    # end


  #end

#end
