//
//  AppDefaults.swift
//  maplysis-swift
//
//  Created by Pericles Maravelakis on 02/07/2018.
//  Licensed under Creative Commons Attribution 4.0 International (CC BY 4.0)
//  https://creativecommons.org/licenses/by/4.0/
//

protocol MapProperties {
	var continiousLocation: Bool { get set }
	var geoCoder: Int { get set }
	var zoomlevel: Int { get set }
	var type: Int { get set }
}

class AppDefaults {

	class func setDefaults() {

		let defaults = UserDefaults.standard

		if defaults.object(forKey: "ContiniousLocation") == nil {
			defaults.set(false, forKey: "ContiniousLocation")
		}

		if defaults.object(forKey: "Geocoder") == nil {
			defaults.set(0, forKey: "Geocoder")
		}

		if defaults.object(forKey: "MapZoomLevel") == nil {
			defaults.set(300, forKey: "MapZoomLevel")
		}

		if defaults.object(forKey: "MapType") == nil {
			defaults.set(0, forKey: "MapType")
		}
	}
}
