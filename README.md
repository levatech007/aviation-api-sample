# Aviation API
Rack based API to use with Volo app.  

## Technologies:
- Rack
- Redis
- Roda Routing Tree
- Sequel
- Mail
- RestClient

## Current Features:
- Request an api key (requires a valid email)
- Generate and save api key  
- Email new api key to client
- Rate limit: currently set at 10 requests per 15 minutes

## Third Party APIs Used:
- [Lufthansa API (OAuth)](https://developer.lufthansa.com)

## Other VOLO apps:

- [Github - Front End](https://github.com/levatech007/volo-react-app)
- [Github - Back End](https://github.com/levatech007/volo_rails_api)

## Future Features:

- Rate Limit (requests per day) - simple version working
