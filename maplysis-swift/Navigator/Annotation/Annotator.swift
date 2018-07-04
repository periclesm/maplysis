//
//  Annotator.swift
//  maplysis-swift
//
//  Created by Pericles Maravelakis on 03/07/2017.
//	periclesm@cloudfields.net
//	Licensed under Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)
//	https://creativecommons.org/licenses/by-sa/4.0/
//

import MapKit

enum GeocoderService: Int {
	case Apple = 0
	case Google
}

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
		
		let gc = UserDefaults.standard.integer(forKey: "Geocoder")
		
		if let service = GeocoderService(rawValue: gc) {
			switch service {
			case GeocoderService.Apple:
				print("Apple Geocoder")
				Geocoders.appleReverseGeocoder(withLocationCoordinates: locationCoord, completion: { (fAddress: String?) in
					locAnnotation.subtitle = fAddress
					sender.addAnnotation(locAnnotation)
					
					let _cLocationUpdates = UserDefaults.standard.bool(forKey: "ContiniousLocation")
					if !_cLocationUpdates {
						sender.selectAnnotation(locAnnotation, animated: true)
					}
				})
				
			case GeocoderService.Google:
				print("Google Geocoder")
				Geocoders.googleReverseGeocoder(withLocationCoordinates: locationCoord, completion: { (fAddress: String?) in
					locAnnotation.subtitle = fAddress
					sender.addAnnotation(locAnnotation)
					
					let _cLocationUpdates = UserDefaults.standard.bool(forKey: "ContiniousLocation")
					if !_cLocationUpdates {
						sender.selectAnnotation(locAnnotation, animated: true)
					}
				})
			}
		}
		else {
			print("Say something nasty here")
		}
	}
}
