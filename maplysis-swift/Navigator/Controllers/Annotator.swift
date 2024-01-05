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
	
	class func displayAnnotation(_ locationCoord: CLLocation?, userSelected: Bool, sender: MKMapView) {
        //If, for any reason, there is no location, just return...
        guard let locationCoord else { return }
        
		let locAnnotation = MKPointAnnotation()
		locAnnotation.coordinate = locationCoord.coordinate
		
		if !userSelected {
			locAnnotation.title = "Current Location";
		}
		else {
			locAnnotation.title = "Selected Location";
		}
		       
        switch AppPreferences.shared.geocoder {
        case .Apple:
            print("Using Apple Geocoder")
            
            let aGeocoder = AppleGeocoder()
            aGeocoder.reverseGeocoder(location: locationCoord) { (addressInfo, error) in
                locAnnotation.subtitle = addressInfo?.formattedAddress
                sender.addAnnotation(locAnnotation)
                
                if !AppPreferences.shared.continuousUpdates {
                    sender.selectAnnotation(locAnnotation, animated: true)
                }
            }
            
            /*
             This is not working. Check the comments in GoogleGeocoder, read the Google Maps API documentation, greate a Key using your account and 
             */
        case .Google:
            print("Google Geocoder")
            
            let gGeocoder = GoogleGeocoder()
            gGeocoder.reverseGeocoder(location: locationCoord) { (addressInfo) in
                locAnnotation.subtitle = addressInfo
                sender.addAnnotation(locAnnotation)
                
                if !AppPreferences.shared.continuousUpdates {
                    sender.selectAnnotation(locAnnotation, animated: true)
                }
            }
        }
	}
}
