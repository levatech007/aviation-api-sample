# scrape airport destinations
class ScrapeAirportDestinations
  require 'nokogiri'
  require 'rest-client'

  BASE_URL = "https://en.wikipedia.org"

  def initialize(airport_wiki_page)
    @airport_wiki_page = airport_wiki_page
  end

  def scrape_destinations
    url = "#{ BASE_URL }#{ @airport_wiki_page }"
    html = RestClient.get(BASE_URL)
    wiki_page = Nokogiri::HTML(html)

    # get data from destinations table
    # return only unique destinations
  end

end
