//
//  AppleGeocoder.swift
//  maplysis
//
//  Created by Pericles Maravelakis on 28/1/20.
//  periclesm@cloudfields.net
//  Licensed under Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)
//  https://creativecommons.org/licenses/by-sa/4.0/
//

import UIKit

struct AddressInfo {
    var address: String = ""
    var subaddress: String = ""
    var locality: String = ""
    var subLocality: String = ""
    var postalCode: String = ""
    var administrativeArea: String = ""
    var subAdministrativeArea: String = ""
    var country: String = ""
    var isoCode: String = ""
    var placemarkName: String = ""
    
    var formattedAddress: String {
        get {
            var formatString: String = ""
            formatString.append(self.address + " " + self.locality + " " + self.postalCode + " " + self.administrativeArea + " " + self.country + " ")
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
                    addressInfo.address = mark?.thoroughfare ?? ""
                    addressInfo.subaddress = mark?.thoroughfare ?? ""
                    addressInfo.locality = mark?.locality ?? ""
                    addressInfo.subLocality = mark?.subLocality ?? ""
                    addressInfo.postalCode = mark?.postalCode ?? ""
                    addressInfo.administrativeArea = mark?.administrativeArea ?? ""
                    addressInfo.subAdministrativeArea = mark?.subAdministrativeArea ?? ""
                    addressInfo.country = mark?.country ?? ""
                    addressInfo.isoCode = mark?.isoCountryCode ?? ""
                    addressInfo.placemarkName =  mark?.name ?? ""
                    
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
