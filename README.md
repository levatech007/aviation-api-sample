# Volo Aviation API
Rack based API (in the future part of Volo app).  

## Technologies:
- Rack
- Redis
- Roda Routing Tree
- Sequel
- Mail
- RestClient

## Current Features:
- Lets a client request an api key (requires a valid email)
- Generates and saves new api key  
- Emails new api key to client
- Rate limit: currently set at 10 requests per 15 minutes
- Version control (URL)
- Request flight schedules between two airports for a given date
- Request target airport's non-stop routes

## Third Party APIs Used:
- [Lufthansa API (OAuth)](https://developer.lufthansa.com)
- Google Apps Scripts to scrape Wikipedia pages for airport data (link coming soon) and manage satic data (airports, airlines, aircraft types)

## Other VOLO apps:

- [Github - Front End](https://github.com/levatech007/volo-react-app)
- [Github - Back End](https://github.com/levatech007/volo_rails_api)

## Future Features:

- Rate Limit (requests per day) - simple version working
- Incorporate more 3rd party APIs to get better flight schedule data (currently only Star Alliance flights are available)
- Destinations are available only for 3 airports at the moment (SFO, LAX, SXM)
- Use Nokogiri inside the app to scrape data instead of managing it through Apps Script
