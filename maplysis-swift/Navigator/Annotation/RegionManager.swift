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
		let _zoomLevel = UserDefaults.standard.double(forKey: "MapZoomLevel")
		let region = MKCoordinateRegion.init(center: locationRegion.coordinate, latitudinalMeters: _zoomLevel, longitudinalMeters: _zoomLevel)
		
		sender.setRegion(sender.regionThatFits(region), animated: true)
	}
}
