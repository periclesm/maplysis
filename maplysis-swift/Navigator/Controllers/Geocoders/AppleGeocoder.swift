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
    
    func reverseGeocoder(coordinates: CLLocation) async -> (Address?, Error?) {
        let aGeocoder = CLGeocoder()
        
        do {
            let placemarks = try await aGeocoder.reverseGeocodeLocation(coordinates)
            var address = Address()
            
            if !placemarks.isEmpty {
                address.placemark = placemarks.first
                debugPrint(placemarks.first as Any)
                return (address, nil)
            }
            else {
                return (nil, nil)
            }
        } catch {
            return (nil, error)
        }
    }
    
    func geocoder(address: String) async -> (CLLocation?, Error?) {
        let aGeocoder = CLGeocoder()
        
        do {
            let placemarks = try await aGeocoder.geocodeAddressString(address)
            if !placemarks.isEmpty {
                return (placemarks.first?.location, nil)
            }
            else {
                return (nil, nil)
            }
        } catch {
            return (nil, error)
        }
    }
}
