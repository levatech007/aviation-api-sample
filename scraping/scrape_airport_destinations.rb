# scrape airport destinations
#class ScrapeAirportDestinations
  require 'nokogiri'
  require 'rest-client'

  # BASE_URL = "https://en.wikipedia.org"
  # def initialize(airport_wiki_page)
  #   @airport_wiki_page = airport_wiki_page
  # end

  def clean_destinations(arr)
  result = []
  seasonal_exists = false
  add_seasonal = false
  add_seasonal_charter = false
  arr.each_with_index do |item, idx|
    # still need to remove refs [123] form item
    if add_seasonal_charter
      result << "Seasonalcharter:" + item
    elsif add_seasonal
      result << "Seasonal:" + item
    elsif item.include?("Seasonalcharter:")
      add_seasonal_charter = true
      add_seasonal = false
      split_str = item.split("Seasonalcharter:")
      first_item = split_str.delete_at(0)
      result << "Seasonal:" + first_item if first_item != ""
      result << "Seasonalcharter:" + split_str.delete_at(0)
    elsif item.include?("Seasonal:")
      add_seasonal = true
      split_str = item.split("Seasonal:")
      first_item = split_str.delete_at(0)
      result << first_item if first_item != ""
      result << "Seasonal:" + split_str.delete_at(0)
    else
      result << item
    end
     add_seasonal = false if arr[idx + 1] && arr[idx + 1].include?("Seasonalcharter:")

  end
  result
end



  #def scrape_destinations
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
                destinations = td.text.delete(" \n").split(/\,(?![\d])/) # there are commas between dates that should not be split at! (beginsApril15,2019)
                links = td.css('a').map {|link| link['href'] }
                cleaned_destinations = clean_destinations(destinations)
                cleaned_links = links.reject { |link| link.include?('#cite_note') }
                cleaned_destinations.zip(cleaned_links)
            end
          end
          p(all_destinations)
          all_destinations
        end
      end
    end

    def format_destinations(data_array)
      regular_destinations = []
      seasonal_destinations = []
      charter_destinations = []
      
      # keep destination (ends ...)
      # remove destinations with (begins ...) or (resumes ...) => future destinations need to be stored separately?
      # return hash { airport_iata_code: "XXX", airport_wiki_page: "/wiki/xxxxxxxx", regular_destinations: [], seasonal_destinations: [], charter_destinations: [] }
    end


  #end

#end
