# scrape airport destinations
#class ScrapeAirportDestinations
  require 'nokogiri'
  require 'rest-client'

  # BASE_URL = "https://en.wikipedia.org"

  # def initialize(airport_wiki_page)
  #   @airport_wiki_page = airport_wiki_page
  # end

  #def scrape_destination
    # Zurich_Airport
    example_url = "https://en.wikipedia.org/wiki/San_Francisco_International_Airport"
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
            td = row.css('td')[1]
              if td
              destinations = td.text.delete(" \n").split(",")
              links = td.css('a').map {|link| link['href'] }
              # also get all value attributes?
              # format destinations strings
              # cleaned_destinations = .....
              # remove unnecessary links
              cleaned_links = links.reject { |link| link.include?('#cite_note') }
              #p(destinations.zip(cleaned_links))
            end
          end
          #p(all_destinations)
        end
      end
    end

    def clean_destinations(arr)
      result = []
      seasonal_exists = false
      add_seasonal = false
      add_seasonal_charter = false
      # initial working function, needs refactoring...not DRY
      arr.each_with_index do |item, idx|

        if add_seasonal_charter
          result << "Seasonalcharter:" + item
        elsif add_seasonal
          result << "Seasonal:" + item
        elsif item.include?("Seasonalcharter:")
          add_seasonal_charter = true
          add_seasonal = false
          split_str = item.split("Seasonalcharter:")
          result << "Seasonal:" + split_str.delete_at(0)
          result << "Seasonalcharter:" + split_str.delete_at(0)
        elsif item.include?("Seasonal:")
          add_seasonal = true
          split_str = item.split("Seasonal:")
          result << split_str.delete_at(0)
          result << "Seasonal:" + split_str.delete_at(0)
        else
          result << item
        end
         add_seasonal = false if arr[idx + 1] && arr[idx + 1].include?("Seasonalcharter:")

      end
      result
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
