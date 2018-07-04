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
		locManager = CLLocationManager()
		isUpdating = false
		super.init()
		
		locManager.delegate = self
		locManager.distanceFilter = kCLDistanceFilterNone
		locManager.desiredAccuracy = kCLLocationAccuracyKilometer
		locManager.allowsBackgroundLocationUpdates = false
	}

	//MARK: - Location Updates
	
	func GetCurrentLocation(sender: Any?) {
		isUpdating = false;
		locManager.requestLocation()

		if sender != nil {
			senderVC = sender
		}
	}
	
	func StartLocationUpdates(sender: Any?) {
		isUpdating = true;
		locManager.startUpdatingLocation()

		if sender != nil {
			senderVC = sender
		}
	}
	
	func StopLocationUpdates(sender: Any?) {
		locManager.stopUpdatingLocation()
		isUpdating = false;

		if sender != nil {
			senderVC = sender
		}
	}

	//MARK: - Location Permissions

	func LocationPermissions() {
		switch CLLocationManager.authorizationStatus() {
		case .notDetermined:
			locManager.requestWhenInUseAuthorization()
//			locManager.requestAlwaysAuthorization()

		case .authorizedWhenInUse, .authorizedAlways:
			break

		case .restricted:
			LocationErrorWithDeviceService(enabled: false)

		case .denied:
			LocationErrorWithDeviceService(enabled: CLLocationManager.locationServicesEnabled())
		}
	}

	//MARK: - Location Delegate
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		
		switch status {
		case .authorizedAlways, .authorizedWhenInUse:
			print("[Location] Location authorized")
			self.GetCurrentLocation(sender: self.senderVC)
			
		default:
			print("[Location] Location rejected")
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("[Location] Failed Location: \(error.localizedDescription)")

		LocationErrorWithDeviceService(enabled: CLLocationManager.locationServicesEnabled())
		locManager.stopUpdatingLocation()
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		print("location: \(String(describing: locations.last))");

		let linfo = LocationInfo.sharedInstance
		linfo.resetLocation()
		linfo.currentLocation = locations.last
		
		NotificationCenter.default.post(name: NSNotification.Name("UpdateLocation"), object: nil, userInfo: nil)
	}

	//MARK: - Error Handling

	func LocationErrorWithDeviceService(enabled: Bool)
	{
		var title: String?
		var message: String?

		if enabled {
			title = "Location permissions"
			message = "You have denied location services for the app"
		}
		else {
			title = "Location services"
			message = "You have disabled or restricted location services on your device"
		}

		let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
		let okbutton = UIAlertAction.init(title: "OK", style: .default, handler: nil)
		alert.addAction(okbutton)

		guard let sender = senderVC else {
			return
		}

		(sender as! UIViewController).present(alert, animated: true, completion:nil)
	}
}
