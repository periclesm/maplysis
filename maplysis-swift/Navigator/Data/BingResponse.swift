//
//  Response.swift
//  maplysis-swift
//
//  Created by Perikles Maravelakis on 6/1/24.
//  periclesm@cloudfields.net
//  Licensed under Creative Commons Attribution 4.0 International (CC BY 4.0)
//  https://creativecommons.org/licenses/by/4.0/
//

import Foundation

struct BingResponse: Decodable {
    var resourceSets: Array<BingResourceSet> = []
    var statusCode: Int
    var statusDescription: String
}

struct BingResourceSet: Decodable {
    var estimatedTotal: Int
    var resources: Array<BingResource>
}

struct BingResource: Decodable {
    var name: String
    var confidence: String
    var point: BingPoint
    var address: BingAddress
    var entityType: String
}

struct BingAddress: Decodable {
    var addressLine: String?
    var adminDistrict: String?
    var adminDistrict2: String?
    var countryRegion: String?
    var formattedAddress: String?
    var locality: String?
    var postalCode: String?
    var countryRegionIso2: String?
}

struct BingPoint: Decodable {
    var type: String
    var coordinates: Array<Double> = []
}
