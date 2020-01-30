//
//  RegionManager.swift
//  maplysis-swift
//
//  Created by Pericles Maravelakis on 03/07/2017.
//	periclesm@cloudfields.net
//  Licensed under Creative Commons Attribution 4.0 International (CC BY 4.0)
//  https://creativecommons.org/licenses/by/4.0/
//

import MapKit

class RegionManager: NSObject {
	
	class func DisplayRegion(locationRegion: CLLocation, sender: MKMapView) {
		let region = MKCoordinateRegion.init(center: locationRegion.coordinate, latitudinalMeters: Double(AppPreferences.shared.mapZoom), longitudinalMeters: Double(AppPreferences.shared.mapZoom))
		
		sender.setRegion(sender.regionThatFits(region), animated: true)
	}
}
