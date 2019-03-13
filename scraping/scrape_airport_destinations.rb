# scrape airport destinations
#class ScrapeAirportDestinations
  require 'nokogiri'
  require 'rest-client'

  # BASE_URL = "https://en.wikipedia.org"

  # def initialize(airport_wiki_page)
  #   @airport_wiki_page = airport_wiki_page
  # end

  #def scrape_destination

    example_url = "https://en.wikipedia.org/wiki/Zurich_Airport"
    # url = "#{ BASE_URL }#{ @airport_wiki_page }"
    html = RestClient.get(example_url)
    # html = RestClient.get(BASE_URL)
    wiki_page = Nokogiri::HTML(html)
    tables    = wiki_page.css('table')

    airlines_destinations_table_found = false

    tables.each do |table|
      rows     = table.css('tr')
      row_name = rows.css('th').text

      if !airlines_destinations_table_found
        # there is no unique id for destinations table
        # find it by <th> value "AirlinesDestinationsRefs" or first instace of "AirlinesDestinations" => contains necessary data
        if row_name == 'AirlinesDestinationsRefs' || row_name == 'AirlinesDestinations'
          # destinations table name 'AirlinesDestinations' applies to both passenger and cargo tables.
          # First is always passenger traffic. Use T/F to make sure only first of the two tables is returned.
          airlines_destinations_table_found = true
          all_destinations = rows.map do |row|
            all_destinations = row.css('td').map do |td|
              destinations = td.text.delete(" \n").split(",")

              links = td.css('a').map {|link| link['href'] }
              # remove unnecessary links
              cleaned_links = links.reject { |link| link.include?('#cite_note') }
              p([destinations,cleaned_links])
            end
          end

        end
      end
    end





    def format_destinations(data_array)
      regular_destinations = []
      seasonal_destinations = []
      charter_destinations = []
      # split string initially by:
      delimiters = ['Seasonal:', 'Seasonalcharter:']
      all_destinations = str.split(Regexp.union(delimiters))

      # for each destinations array:
      # split to individual destinations
      # remove refs ex. [123]
      # remove destinations with (begins...) (resumes...) for now
      # keep destination
      # remove destinations with (begins ...) or (resumes ...) => future destinations need to be stored separately?
      # return hash { regular_destinations: [], seasonal_destinations: [] }
    end

    def format_wiki_links(links)
      # links is array of arrays
      # remove nil or []
      #
    end


  #end

#end
