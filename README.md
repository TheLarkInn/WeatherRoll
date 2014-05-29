WeatherRoll
===========

This is a proof of concept app designed to show a MapView, and then grab weather information as you change locations on the app. 

To use
===========
In iOS Simulator, you should set your location to a valid location. Fields will show as (Null) otherwise. It was too time consuming to account for fields being null since if you are in a valid US or International City, your current location would instantly access your weather information


Included Webservices
===========
- Weather Underground
  - Used to fetch weather data in realtime. Free api, and shouldn't reach daily request limit. 
  - http://www.wunderground.com/weather/api for more information
