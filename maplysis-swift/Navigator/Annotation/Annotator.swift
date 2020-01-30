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
	
	class func DisplayAnnotation(_ locationCoord:CLLocation, userSelected: Bool, sender: MKMapView) {
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
            print("Apple Geocoder")
            
            AppleGeocoder.reverseGeocoder(location: locationCoord) { (addressInfo, error) in
                locAnnotation.subtitle = addressInfo?.formattedAddress
                sender.addAnnotation(locAnnotation)
                
                if !AppPreferences.shared.continiousUpdates {
                    sender.selectAnnotation(locAnnotation, animated: true)
                }
            }
            
        case .Google:
            print("Google Geocoder")
            
            GoogleGeocoder.reverseGeocoder(location: locationCoord) { (addressInfo) in
                locAnnotation.subtitle = addressInfo
                sender.addAnnotation(locAnnotation)
                
                if !AppPreferences.shared.continiousUpdates {
                    sender.selectAnnotation(locAnnotation, animated: true)
                }
            }
        }
	}
}
