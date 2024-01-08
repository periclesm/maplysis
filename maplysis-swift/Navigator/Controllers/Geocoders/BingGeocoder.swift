//
//  BingGeocoder.swift
//  maplysis-swift
//
//  Created by Perikles Maravelakis on 6/1/24.
//  periclesm@cloudfields.net
//  Licensed under Creative Commons Attribution 4.0 International (CC BY 4.0)
//  https://creativecommons.org/licenses/by/4.0/
//

import Foundation
import CoreLocation

class BingGeocoder: NSObject {
    
    func reverseGeocoder(coordinates: CLLocation) async -> String? {
        let latString = "\(coordinates.coordinate.latitude)"
        let lonString = "\(coordinates.coordinate.longitude)"
        
        let urlRequestString = "https://dev.virtualearth.net/REST/v1/Locations/\(latString),\(lonString)?includeEntityTypes=Address, Postcode1,AdminDivision1,CountryRegion&includeNeighborhood=0&include=ciso2&key=\(AppPreferences.shared.BingMapsAPIKey)"
            .addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let urlRequest = URL(string: urlRequestString!)
        var request = URLRequest(url: urlRequest!, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 20)
        request.httpMethod = "GET"
        
        var responseData: (Data, URLResponse)
        
        do {
            let session = URLSession(configuration: URLSessionConfiguration.default)
            responseData = try await session.data(for: request)
            
            guard (responseData.1 as? HTTPURLResponse)?.statusCode == 200 else {
                debugPrint("Response HTTP Code: \(String(describing: (responseData.1 as? HTTPURLResponse)?.statusCode))")
                return nil
            }
            
            let data: BingResponse = parseData(data: responseData.0)
            //debugPrint(data)
            
            return data.resourceSets.first?.resources.first?.name
        } catch {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
    // Not really used but it's just there...
    func geocoder(address: String) async -> CLLocation? {
        let urlRequestString = "http://dev.virtualearth.net/REST/v1/Locations/\(address)?includeNeighborhood=0&maxResults=1&include={includeValue}&key=\(AppPreferences.shared.BingMapsAPIKey)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let urlRequest = URL(string: urlRequestString!)
        var request = URLRequest(url: urlRequest!, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 20)
        request.httpMethod = "GET"
        
        var responseData: (Data, URLResponse)
        
        do {
            let session = URLSession(configuration: URLSessionConfiguration.default)
            responseData = try await session.data(for: request)
            
            guard (responseData.1 as? HTTPURLResponse)?.statusCode == 200 else {
                debugPrint("Response HTTP Code: \(String(describing: (responseData.1 as? HTTPURLResponse)?.statusCode))")
                return nil
            }
            
            let data: BingResponse = parseData(data: responseData.0)
            //debugPrint(data)
            
            let lat = data.resourceSets.first?.resources.first?.point.coordinates.first ?? 0.0
            let lon = data.resourceSets.first?.resources.first?.point.coordinates[1] ?? 0.0
            return CLLocation(latitude: Double(lat), longitude: Double(lon))
        } catch {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
    
    //TODO: - Need to move the network code and the Parsing code to a separate class for Bing and Google reuse...
    private func parseData<T: Decodable>(data: Data) -> T {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            debugPrint("Parsing error: \(error.localizedDescription)")
            fatalError("error in decoding")
        }
    }
}
