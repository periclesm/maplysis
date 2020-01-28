# maplysis
A simple iOS app in swift using MapKit and Geocoding to display information and map functionality.

This is a usecase application with basic functionality and can be used as a starting point for building your ideas and services.

Licensed under Creative Commons Attribution 4.0 International (CC BY 4.0)
https://creativecommons.org/licenses/by/4.0/

This app...
* is up to iOS 13 with Swift 5
* supports Light/Dark UI mode
* Uses Geocoders by Apple and Google
	* Apple geocoder is part of CoreLocation Framework
	* Google geocoder information can be found at https://developers.google.com/maps/documentation/geocoding/start
	* both geocoder and reverse geocoder are written in Swift and Obj-C (not used by the compiler but files are there)
* Basic Region and Annotation functionality
	
	
	
**Important note:** Google Geocoder uses Google Maps Platform APIs. This requires you have a valid API key to request from the service and retrieve data. For obvious reasons, I have not included any key in the app and running any Google geocoding functionality will fail. To learn and get your keys, see https://developers.google.com/maps/gmp-get-started
