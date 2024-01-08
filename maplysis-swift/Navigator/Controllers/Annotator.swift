//
//  Annotator.swift
//  maplysis-swift
//
//  Created by Pericles Maravelakis on 03/07/2017.
//	periclesm@cloudfields.net
//  Licensed under Creative Commons Attribution 4.0 International (CC BY 4.0)
//  https://creativecommons.org/licenses/by/4.0/
//

import MapKit

class Annotator: NSObject {
	
	class func displayAnnotation(_ coordinates: CLLocation?, userSelected: Bool) async -> MKPointAnnotation? {
        //If, for any reason, there is no location, just return...
        guard let coordinates else { return nil }
        
        let annotation = MKPointAnnotation()
		annotation.coordinate = coordinates.coordinate
        annotation.subtitle = String(format: "%.3f, %.3f", coordinates.coordinate.latitude, coordinates.coordinate.longitude)
		       
        switch AppPreferences.shared.geocoder {
        
        case .Apple:
            debugPrint("Using Apple Geocoding")
            
            let aGeocoder = AppleGeocoder()
            let address = await aGeocoder.reverseGeocoder(coordinates: coordinates)
            if let error = address.1 {
                debugPrint(error.localizedDescription)
                return nil
            }
            else {
                if let info = address.0 {
                    annotation.title = info.formattedAddress
                }
            }
            
            /*
             This is not working. Check the comments in GoogleGeocoder, read the Google Maps API documentation, greate a Key using your account and
             */
        case .Google:
            debugPrint("Using Google Geocoding")
            
//            let gGeocoder = GoogleGeocoder()
//            gGeocoder.reverseGeocoder(location: locationCoord) { (addressInfo) in
//                locAnnotation.subtitle = addressInfo
//                sender.addAnnotation(locAnnotation)
//                
//                if !AppPreferences.shared.continuousUpdates {
//                    sender.selectAnnotation(locAnnotation, animated: true)
//                }
//            }
            
        case .Bing:
            debugPrint("Using Bing Maps Geocoding ")
            
            let bmGeocoder = BingGeocoder()
            let address = await bmGeocoder.reverseGeocoder(coordinates: coordinates)
            annotation.title = address
            #warning ("check for error in Bing")
        }
        
        return annotation
	}
}
