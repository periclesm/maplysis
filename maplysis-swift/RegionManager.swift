//
//  RegionManager.swift
//  maplysis-swift
//
//  Created by Pericles Maravelakis on 03/07/2017.
//	periclesm@cloudfields.net
//	Licensed under Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)
//	https://creativecommons.org/licenses/by-sa/4.0/
//

import UIKit
import CoreLocation
import MapKit

class RegionManager: NSObject {
	
	class func DisplayRegion(locationRegion: CLLocation, sender: MKMapView) {
		let _zoomLevel = UserDefaults.standard.double(forKey: "MapZoomLevel")
		let region = MKCoordinateRegionMakeWithDistance(locationRegion.coordinate, _zoomLevel, _zoomLevel)
		
//		(sender as? MKMapView)?.setRegion(((sender as? MKMapView)?.regionThatFits(region))!, animated: true)
		sender.setRegion(sender.regionThatFits(region), animated: true)
		
	}
}
