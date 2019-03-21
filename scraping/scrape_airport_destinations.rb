# scrape airport destinations
#class ScrapeAirportDestinations
  require 'nokogiri'
  require 'rest-client'

  # BASE_URL = "https://en.wikipedia.org"
  # def initialize(airport_wiki_page)
  #   @airport_wiki_page = airport_wiki_page
  # end

  def clean_destinations(arr)
  # function works but needs refactoring, not DRY & needs better variable names
  # add 'Seasonal:' or 'Seasonalcharter:' to respective destinations
    result = []
    # Destinations are ordered Reagular first, Seasonal second, Seasonalcharter third but one or more may not be present
    # seasonal_exists is needed to check if there are Seasonal destinations;
    # without this var, splitting "LondonSeasonalcharter:Oslo" would return ["Seasonal:London", "Seasonalcharter:Oslo"]
    # when it should return ["London", "Seasonalcharter:Oslo"]
    seasonal_exists = false
    add_seasonal = false
    add_seasonal_charter = false
    arr.each_with_index do |dest, idx|
      item = dest.gsub(/\[[^\]]*\]/, '') # remove citations: [123]
      if add_seasonal_charter
        result << "Seasonalcharter:" + item
      elsif add_seasonal
        result << "Seasonal:" + item
      elsif item.include?("Seasonalcharter:")
        add_seasonal_charter = true
        add_seasonal = false
        split_str = item.split("Seasonalcharter:")
        first_item = split_str.delete_at(0)

        if seasonal_exists && first_item != ""
          result << "Seasonal:" + first_item
        elsif first_item != ""
          result << first_item
        end
        result << "Seasonalcharter:" + split_str.delete_at(0)
      elsif item.include?("Seasonal:")
        add_seasonal = true
        seasonal_exists = true
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

# clean destinations strings that includes routes with 'begins', 'resumes' or 'ends' dates
# "London(beginsApril15,2020)" => ["London", "begins", "April5,2020"]
def format_transitional_destinations(dest_str)
  result = []
  types = ['begins', 'ends', 'resumes']
  match = types.find { |type| dest_str.include?(type) }
  result_arr = dest_str.split("(")
  result.push(result_arr[0])
  date = result_arr[1].gsub(/#{ match }|\)/, '')
  result.push(match, date)
  result
end

def format_destinations(data_array)
# => each 'kind_of'_destinations = [{}, {}, {}]
# => each object comprises of:
#   {
#   destination: "Airport",
#   airport_wiki: "/wiki/Airport_Page",
#   current: true, # not a future destination # if false, begins: date will be included
#   seasonal: false,
#   seasonal_charter: false,
#   begins: date, # included if true
#   ends: date, # included if true
# }
  regular_destinations = []
  seasonal_destinations = []
  charter_destinations = []

  # loop through destinations data
  data_array.map do |single_airline_destinations|
    single_airline_destinations.map do |destination|

      if destination[0].match(/begins|resumes|ends/)
          p(format_transitional_destinations(destination[0]))
      # loop through individual airline destinations
      # each array in it, check [0] for 'ending', 'begins', 'resumes'
      # If it includes the above:
      # format_transitional_destinations(str)
      else
        p(destination[0]) 
      end
    end
  end
  # return hash { airport_iata_code: "XXX", airport_wiki_page: "/wiki/xxxxxxxx", regular_destinations: [], seasonal_destinations: [], charter_destinations: [] }

end

  #def scrape_destinations
    # Zurich_Airport
    example_url = "https://en.wikipedia.org/wiki/Tallinn_Airport"
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
          #p(all_destinations.compact)
          p(format_destinations(all_destinations.compact))
          # format_destinations(all_destinations)
        end
      end
    end




  #end

#end
