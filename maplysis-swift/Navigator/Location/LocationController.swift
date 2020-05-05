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

class LocationController: NSObject, CLLocationManagerDelegate {

	static let sharedInstance = LocationController()
	var locManager: CLLocationManager = CLLocationManager()
	var isUpdating: Bool = false
	var senderVC: Any?
	
	override init() {
        super.init()
		
		locManager.delegate = self
		locManager.distanceFilter = kCLDistanceFilterNone
		locManager.desiredAccuracy = kCLLocationAccuracyKilometer
		locManager.allowsBackgroundLocationUpdates = false
	}

	//MARK: - Location Updates
	
	func getCurrentLocation(sender: Any?) {
		isUpdating = false;
		locManager.requestLocation()

		if sender != nil {
			senderVC = sender
		}
	}
	
	func startLocationUpdates(sender: Any?) {
		isUpdating = true;
		locManager.startUpdatingLocation()

		if sender != nil {
			senderVC = sender
		}
	}
	
	func stopLocationUpdates(sender: Any?) {
		locManager.stopUpdatingLocation()
		isUpdating = false;

		if sender != nil {
			senderVC = sender
		}
	}

	//MARK: - Location Permissions

	func locationPermissions() {
		switch CLLocationManager.authorizationStatus() {
		case .notDetermined:
			locManager.requestWhenInUseAuthorization()
//			locManager.requestAlwaysAuthorization()

		case .authorizedWhenInUse, .authorizedAlways:
			break

		case .restricted:
			locationErrorWithDeviceService(enabled: false)

		case .denied:
			locationErrorWithDeviceService(enabled: CLLocationManager.locationServicesEnabled())
            
        default: break
		}
	}

	//MARK: - Location Delegate
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		
		switch status {
		case .authorizedAlways, .authorizedWhenInUse:
			print("[Location] Location authorized")
			self.getCurrentLocation(sender: self.senderVC)
			
		default:
			print("[Location] Location rejected")
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("[Location] Failed Location: \(error.localizedDescription)")

		locationErrorWithDeviceService(enabled: CLLocationManager.locationServicesEnabled())
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

	func locationErrorWithDeviceService(enabled: Bool)
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
