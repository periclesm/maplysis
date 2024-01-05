//
//  Address.swift
//  maplysis-swift
//
//  Created by Perikles Maravelakis on 5/1/24.
//  periclesm@cloudfields.net
//  Licensed under Creative Commons Attribution 4.0 International (CC BY 4.0)
//  https://creativecommons.org/licenses/by/4.0/
//

import Foundation
import CoreLocation

struct Address {
    
    var placemark: CLPlacemark?
    var formattedAddress: String {
        get {
            var formatString: String = ""
            
            if let thoroughfare = placemark?.thoroughfare {
                formatString.append("\(thoroughfare) ")
            }
            
            if let subThoroughfare = placemark?.subThoroughfare {
                formatString.append("\(subThoroughfare) ")
            }
            
            if let postalCode = placemark?.postalCode {
                formatString.append("\(postalCode) ")
            }
            
            if let administrativeArea = placemark?.administrativeArea {
                formatString.append("\(administrativeArea) ")
            }
            
            if let country = placemark?.country {
                formatString.append("\(country)")
            }
            
            return formatString.replacingOccurrences(of: "  ", with: " ").trimmingCharacters(in: .whitespaces)
        }
    }
}
