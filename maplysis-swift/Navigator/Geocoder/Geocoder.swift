//
//  Geocoder.swift
//  maplysis-swift
//
//  Created by Pericles Maravelakis on 03/07/2017.
//	periclesm@cloudfields.net
//	Licensed under Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)
//	https://creativecommons.org/licenses/by-sa/4.0/
//

import UIKit
import CoreLocation

class Geocoder: NSObject {
	
//MARK : - Apple Geocoding
	
	class func AppleReverseGeocoder(location: CLLocation, completion: @escaping (_ fAddress: String) -> Void) {
		
		CLGeocoder().reverseGeocodeLocation(location) {(placemarks: [CLPlacemark]?, error: Error?) in
			
			if (placemarks?.count)! > 0 {
				let mark = placemarks?.first
				var addressString : String
				let addrDict = mark?.addressDictionary?["FormattedAddressLines"]
				
				for detail in addrDict {
					addressString.append(" \(detail)")
				}
				
				completion(addressString)
			}
		}
	}
	
	
	func AppleGeocoder(address: String, completion: @escaping (_ location: CLLocation) -> Void) {
		
		CLGeocoder().geocodeAddressString(address) {(placemarks: [CLPlacemark]?, error: Error?) in
			
			if (placemarks?.count)! > 0 {
				let mark = placemarks?.first
				completion((mark?.location)!)
			}
		}
	}
}
