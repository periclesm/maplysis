//
//  AppleGeocoder.swift
//  maplysis
//
//  Created by Pericles Maravelakis on 28/1/20.
//  periclesm@cloudfields.net
//  Licensed under Creative Commons Attribution 4.0 International (CC BY 4.0)
//  https://creativecommons.org/licenses/by/4.0/
//

import UIKit
import CoreLocation

class AppleGeocoder: NSObject {
    class func reverseGeocoder(location: CLLocation, completion: @escaping (Address?, Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                debugPrint(error!.localizedDescription)
                completion(nil, error)
            }
            else {
                if let marks = placemarks {
                    let mark = marks.first
                    
                    var addressInfo = Address()
                    addressInfo.placemark = mark
                    debugPrint(mark as Any)
                    completion(addressInfo, nil)
                }
            }
        }
    }
    
    class func geocoder(address: String, completion: @escaping (CLLocation?, Error?) -> ()) {
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            if error != nil {
                debugPrint(error!.localizedDescription)
                completion(nil, error)
            }
            else {
                if let marks = placemarks {
                    let mark = marks.first
                    completion(mark?.location, nil)
                }
            }
        }
    }
}
