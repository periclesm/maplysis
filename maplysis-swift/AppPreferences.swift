//
//  AppPreferences.swift
//  maplysis-swift
//
//  Created by Pericles Maravelakis on 30/1/20.
//  Copyright © 2020 cloudfields. All rights reserved.
//

import UIKit

enum GeocoderService: Int {
    case Apple = 0
    case Google
}

enum MapType: Int {
    case standard = 0
    case satellite
    case hybrid
}

class AppPreferences: NSObject {
    
    static var shared = AppPreferences()
    var defaults = UserDefaults.standard
    
    var geocoder: GeocoderService {
        set {
			defaults.set(newValue.rawValue, forKey: "Geocoder")
		}
        get {
            if defaults.object(forKey: "Geocoder") != nil {
                return GeocoderService(rawValue: defaults.integer(forKey: "Geocoder"))!
            }
            else {
                return GeocoderService(rawValue: 0)!
            }
        }
    }
    
    var continuousUpdates: Bool {
        set {
			defaults.set(newValue, forKey: "ContinuousLocation")
			
		}
        get {
            if defaults.object(forKey: "ContinuousLocation") != nil {
                return defaults.bool(forKey: "ContinuousLocation")
            }
            else {
                return false
            }
        }
    }
    
    var mapZoom: Float {
        set {
			defaults.set(newValue, forKey: "MapZoomLevel")
			
		}
        get {
            if defaults.object(forKey: "MapZoomLevel") != nil {
                return defaults.float(forKey: "MapZoomLevel")
            }
            else {
                return 500.0
            }
        }
    }
    
    var mapType: MapType {
        set {
			defaults.set(newValue.rawValue, forKey: "MapType")
			
		}
        get {
            if defaults.object(forKey: "MapType") != nil {
                return MapType(rawValue: defaults.integer(forKey: "MapType"))!
            }
            else {
                return MapType(rawValue: 0)!
            }
        }
        
    }
}
