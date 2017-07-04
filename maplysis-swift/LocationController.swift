//
//  LocationController.swift
//  maplysis-swift
//
//  Created by Pericles Maravelakis on 02/07/2017.
//	periclesm@cloudfields.net
//	Licensed under Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)
//	https://creativecommons.org/licenses/by-sa/4.0/
//

import UIKit
import CoreLocation

class LocationController: NSObject, CLLocationManagerDelegate {
	static let sharedInstance = LocationController()
	var locManager: CLLocationManager
	var isUpdating: Bool
	var senderVC: Any?
	
	override init() {
		locManager = CLLocationManager.init()
		isUpdating = false
		super.init()
		
		locManager.delegate = self
		locManager.distanceFilter = kCLDistanceFilterNone
		locManager.desiredAccuracy = kCLLocationAccuracyKilometer
		
		LocationPermissions()
	}
	
	func GetCurrentLocation(sender: AnyObject?) {
		locManager.requestLocation()
		isUpdating = false;
		senderVC = sender
	}
	
	func StartLocationUpdates(sender: AnyObject?) {
		locManager.startUpdatingLocation()
		isUpdating = true;
		senderVC = sender
	}
	
	func StopLocationUpdates(sender: AnyObject?) {
		locManager.stopUpdatingLocation()
		isUpdating = false;
		senderVC = sender
	}
	
	
	func LocationPermissions(){
		if CLLocationManager.locationServicesEnabled() {
			let status = CLLocationManager.authorizationStatus()
			
			switch status {
			case .notDetermined:
				locManager.requestWhenInUseAuthorization()
				
			case .authorizedWhenInUse, .authorizedAlways:
				//do nothing all is well
				break
				
			default:
				LocationErrorWithDeviceServiceEnabled(enabled: true)
				break
			}
		}
		else {
			LocationErrorWithDeviceServiceEnabled(enabled: false)
		}
	}
	
	func LocationErrorWithDeviceServiceEnabled(enabled: Bool)
	{
		var title: String?
		var message: String?
		
		if enabled {
			title = "Location permissions"
			message = "You have denied location services for the app"
		}
		else {
			title = "Location services"
			message = "You have disabled location services on your device"
		}
		
		let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
		let okbutton = UIAlertAction.init(title: "OK", style: .default, handler: nil)
		alert.addAction(okbutton)
		
		(senderVC as! UIViewController).present(alert, animated: true, completion:nil)
	}
	
	//MARK: - Location Delegate
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		
		switch status {
		case .authorizedAlways, .authorizedWhenInUse:
			print("[Location] Location authorized after permission change")
		default:
			print("[Location] Location rejected after permission change")
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("[Location] Failed Location: \(error.localizedDescription)")
		if CLLocationManager.locationServicesEnabled() {
			LocationErrorWithDeviceServiceEnabled(enabled: true)
		}
		else {
			LocationErrorWithDeviceServiceEnabled(enabled: false)
		}
		
		locManager.stopUpdatingLocation()
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		let currentLoc = locations.last
		let linfo = LocationInfo.sharedInstance
		linfo.currentLocation = currentLoc
		
		print("location: \(String(describing: linfo.currentLocation))");
		NotificationCenter.default.post(name: NSNotification.Name("UpdateLocation"), object: nil, userInfo: nil)
	}

}
