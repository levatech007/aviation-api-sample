# scrape airport destinations
#class ScrapeAirportDestinations
  require 'nokogiri'
  require 'rest-client'

  # BASE_URL = "https://en.wikipedia.org"

  # def initialize(airport_wiki_page)
  #   @airport_wiki_page = airport_wiki_page
  # end

  #def scrape_destinations


    example_url = "https://en.wikipedia.org/wiki/San_Francisco_International_Airport"
    # url = "#{ BASE_URL }#{ @airport_wiki_page }"
    html = RestClient.get(example_url)
    # html = RestClient.get(BASE_URL)
    wiki_page = Nokogiri::HTML(html)
    tables = wiki_page.css('table')
    result = []
    tables.each do |table|
      rows = table.css('tr')
      row_name = rows.css('th').text
      if row_name == "AirlinesDestinationsRefs" # => there is no unique id for table, find it by <th> values
      #   p("Selected row: " + row_name)
        all_rows_text = rows.map do |row|
          row.css('td').map(&:text)
        end
        p(*all_rows_text)
        all_rows_text.each do |row|
          if !row.empty?
            result.push(row[1].gsub(/\s+/, "")) # row[1] is destinations column, remove all whitespace
          end
        end
        p(result)
        # format_scraped_data(result)
      end

    end

    def format_scraped_data
      update_dates = []
      regular_destinations = []
      seasonal_destinations = []
      # for each destinations array:
      # split to individual destinations
      # remove refs ex. [123]
      # get dates from (ending March 31, 2019), (begins ...), (resumes ...)
      # remove destinations with (begins ...) or (resumes ...) => future destinations need to be stored separately?
      #keep track of schedule changes with update_dates
      # return hash { update_dates: [], regular_destinations: [].uniq, seasonal_destinations: [] }
    end
    #
    # return only unique destinations



  #end

#end
