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

struct AddressInfo {
    var placemark: CLPlacemark? = nil
    
    var formattedAddress: String {
        get {
            var formatString: String = ""
            if placemark != nil {
                formatString.append(contentsOf: (self.placemark?.thoroughfare ?? "") + " ")
                formatString.append(contentsOf: (self.placemark?.subThoroughfare ?? "") + " ")
                formatString.append(contentsOf: (self.placemark?.postalCode ?? "") + " ")
                formatString.append(contentsOf: (self.placemark?.administrativeArea ?? "") + " ")
                formatString.append(contentsOf: self.placemark?.country ?? "")
            }
            
            return formatString.replacingOccurrences(of: "  ", with: " ").trimmingCharacters(in: .whitespaces)
        }
    }
}

class AppleGeocoder: NSObject {
    
    class func reverseGeocoder(location: CLLocation, completion: @escaping (AddressInfo?, Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, err) in
            if err != nil {
                debugPrint("\(err!.localizedDescription)")
                completion(nil, err)
            }
            else {
                if let marks = placemarks {
                    let mark = marks.first
                    
                    var addressInfo = AddressInfo()
                    addressInfo.placemark = mark
                    debugPrint(mark as Any)
                    completion(addressInfo, nil)
                }
            }
        }
    }
    
    class func geocoder(address: String, completion: @escaping (CLLocation?, Error?) -> ()) {
        CLGeocoder().geocodeAddressString(address) { (placemarks, err) in
            if err != nil {
                debugPrint("\(err!.localizedDescription)")
                completion(nil, err)
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
