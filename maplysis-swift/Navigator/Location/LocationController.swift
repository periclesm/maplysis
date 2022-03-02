//
//  LocationController.swift
//  maplysis-swift
//
//  Created by Pericles Maravelakis on 02/07/2017.
//	periclesm@cloudfields.net
//  Licensed under Creative Commons Attribution 4.0 International (CC BY 4.0)
//  https://creativecommons.org/licenses/by/4.0/
//

import UIKit
import CoreLocation

class LocationController: NSObject {

	var mapDelegate: MapDelegate?
	var locManager = CLLocationManager()
	var isUpdating = false
	
	override init() {
        super.init()
		
		locManager.delegate = self
		locManager.distanceFilter = kCLDistanceFilterNone
		locManager.desiredAccuracy = kCLLocationAccuracyBest
		locManager.allowsBackgroundLocationUpdates = false
	}
	
	//MARK: - Location Permissions
	
	func locationPermissions() {
		switch locManager.authorizationStatus {
			
		case .notDetermined:
			locManager.requestWhenInUseAuthorization()
			
		case .restricted:
			mapDelegate?.locationErrorWithDeviceService(enabled: false)
			
		case .denied:
			mapDelegate?.locationErrorWithDeviceService(enabled: CLLocationManager.locationServicesEnabled())
			
		case .authorizedWhenInUse, .authorizedAlways:
			fallthrough
			
		default:
			break
		}
	}
	
	func accuracyPermissions() {
		switch locManager.accuracyAuthorization {
		case .fullAccuracy:
			break
			
		case .reducedAccuracy:
			break
			
		default:
			break
		}
	}

	//MARK: - Location Updates
	
	func getCurrentLocation() {
		isUpdating = false;
		locManager.requestLocation()
	}
	
	func startLocationUpdates() {
		isUpdating = true;
		locManager.startUpdatingLocation()
	}
	
	func stopLocationUpdates() {
		locManager.stopUpdatingLocation()
		isUpdating = false;
	}
}

extension LocationController: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch status {
		case .authorizedAlways, .authorizedWhenInUse:
			debugPrint("[Location] Location authorized")
			self.getCurrentLocation()
			
		default:
			debugPrint("[Location] Location rejected")
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("[Location] Failed Location: \(error.localizedDescription)")
		
		//mapDelegate?.locationErrorWithDeviceService(enabled: CLLocationManager.locationServicesEnabled())
		locManager.stopUpdatingLocation()
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		print("location: \(String(describing: locations.last))");
		
		let linfo = LocationInfo.shared
		linfo.resetLocation()
		linfo.currentLocation = locations.last
		
		mapDelegate?.displayLocation()
	}
}
