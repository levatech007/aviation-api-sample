# Volo Aviation API
*** Please note that this is only a small sample code for this api ***

Rack based API (in the future part of Volo app).  

## Technologies:
- Rack
- Redis
- Roda Routing Tree
- Sequel
- Mail
- RestClient
- Nokogiri
- Heroku

## Current Features:
- Client can request an api key with a valid email
- Generate, save, and email new api key  
- Rate limited: currently set at 10 requests per 15 minutes
- URL version control (/api/v1/...)
- Request flight schedules between two airports for a given date
- Request target airport's non-stop routes

## Third Party APIs Used:
- [Lufthansa API (OAuth)](https://developer.lufthansa.com)
-  Nokogiri to scrape Wikipedia pages for airport data and Google Apps Scripts (link coming soon) to manage static data (airports, airlines and aircraft types)

## Other VOLO apps:

- [Github - Front End](https://github.com/levatech007/volo-react-app-example)
- [Github - Back End](https://github.com/levatech007/volo-rails-api-example)

## Future Features:

- Tiered rate limit (requests per day) - simple version working
- Incorporate more 3rd party APIs to get better flight schedule data (currently only Star Alliance flights are available)
