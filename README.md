# Aviation API
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

## Third Party APIs Used:
- [Lufthansa API (OAuth)](https://developer.lufthansa.com)

## Other VOLO apps:

- [Github - Front End](https://github.com/levatech007/volo-react-app)
- [Github - Back End](https://github.com/levatech007/volo_rails_api)

## Future Features:

- Rate Limit (requests per day) - simple version working
- Incorporate more 3rd party APIs to get better flight schedule data
