//
//  GoogleGeocoder.swift
//  maplysis-swift
//
//  Created by Pericles Maravelakis on 28/1/20.
//	periclesm@cloudfields.net
//  Licensed under Creative Commons Attribution 4.0 International (CC BY 4.0)
//  https://creativecommons.org/licenses/by/4.0/
//

import UIKit
import CoreLocation

class GoogleGeocoder: NSObject {
    
    /*!
     * Doing the simplest Reverse geocoding here.
     * For more complex and analytical Geocoding, check the Google documentation
     * https://developers.google.com/maps/documentation/geocoding/intro#ReverseGeocoding
     * ALSO NOTE: Since the introduction to the API Keys, this service will work only if you provide with a valid key. For obvious reasons, such key is not included here...
     */
    
    /*
     Sidenote: I must create a Google Cloud with Billing info to get a working API key and test the Google Maps API.
     Also I need to await/async this code.
     Duh... stay tuned...
     */
    func reverseGeocoder(coordinates: CLLocation, completion: @escaping (String?) -> ()) {
        DispatchQueue.main.async {
            let latString = "\(coordinates.coordinate.latitude)"
            let lonString = "\(coordinates.coordinate.longitude)"
            
            //make sure you enter the correct API key for Google Geocoding API in App Preferences
            let requestURLString = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latString),\(lonString)&key=\(AppPreferences.shared.GMapsAPIKey)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            
            let requestURL = URL(string: requestURLString!)
            
            do {
				//TODO: - Change this into an async URLSession call
                let responseData = try Data(contentsOf: requestURL!, options: .mappedIfSafe)
                
                if responseData.count > 0 {
                    do {
                        //TODO: - Sigh... yeah, needs Decodable stuff here...
                        let responseDict = try JSONSerialization.jsonObject(with: responseData, options: []) as! Dictionary<String,Any>
                        let status = responseDict["status"] as! String
                        
                        if status.lowercased() == "ok" {
                            let result = (responseDict["results"] as? Array<Any>)?.first as! Dictionary<AnyHashable,Any>
                            let grgAddress = result["formatted_address"] as? String;
                            completion(grgAddress);
                        }
                        else {
                            completion(nil)
                        }
                    } catch let err {
                        debugPrint("Error parsing json data: \(err.localizedDescription)")
                        completion(nil)
                    }
                }
            }
            catch {
                debugPrint("Error fetching data: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    /*!
     * Same simple Geocoding as in Reverse.
     * For more complex and analytical Geocoding, check the Google documentation
     * https://developers.google.com/maps/documentation/geocoding/intro#geocoding
     * ALSO NOTE: Since the introduction to the API Keys, this service will work only if you provide with a valid key.
     */
    
    /*
     Sidenote: same as above even if this is not used in the app.
     */
    func geocoder(address: String, completion: @escaping (CLLocation?) -> ()) {
        DispatchQueue.main.async {
            let formattedAddressString = address.replacingOccurrences(of: " ", with: "+")
            
            //make sure you enter the correct API key for Google Geocoding API
            let requestURLString = "https://maps.googleapis.com/maps/api/geocode/json?address=\(formattedAddressString)&key=<your-api-key>".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            
            let requestURL = URL(string: requestURLString!)
            
            do {
                let responseData = try Data(contentsOf: requestURL!, options: .mappedIfSafe)
                
                if responseData.count > 0 {
                    do {
                        let responseDict = try JSONSerialization.jsonObject(with: responseData, options: []) as! Dictionary<String,Any>
                        let status = responseDict["status"] as! String
                        
                        if status.lowercased() == "ok" {
                            let result = (responseDict["results"] as? Array<Any>)?.first as! Dictionary<AnyHashable,Any>
                            let geometry = result["geometry"] as! Dictionary<AnyHashable, Any>
                            let location = geometry["location"] as! Dictionary<String,Double>
                            
                            let latitude = location["lat"]!
                            let longtitude = location["lng"]!
                            
                            let gglocation = CLLocation(latitude: latitude, longitude: longtitude)
                            completion(gglocation)
                        }
                        else {
                            completion(nil)
                        }
                        
                    } catch let err {
                        debugPrint("Error parsing json data: \(err.localizedDescription)")
                        completion(nil)
                    }
                }
            }
            catch {
                debugPrint("Error fetching data: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}
