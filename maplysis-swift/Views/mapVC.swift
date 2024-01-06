//
//  mapController.swift
//  maplysis-swift
//
//  Created by Pericles Maravelakis on 02/07/2017.
//	periclesm@cloudfields.net
//  Licensed under Creative Commons Attribution 4.0 International (CC BY 4.0)
//  https://creativecommons.org/licenses/by/4.0/
//

import UIKit
import MapKit

protocol MapDelegate {
	func displayLocation()
	func locationErrorWithDeviceService(enabled: Bool)
}

class mapVC: UIViewController {
	
	@IBOutlet weak var locationButton: MALocationButton!
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var longPress: UIGestureRecognizer!
	
	let locController = LocationController()

    override func viewDidLoad() {
		super.viewDidLoad()

		locController.mapDelegate = self
		locController.locationPermissions()
        locController.stopLocationUpdates()
        
        locationButton.setState(state: .standard)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OptionsSegue" {
            let dnav = segue.destination as! UINavigationController
            let dvc = dnav.viewControllers.first as! optionsVC
            optionsCallbacks(dvc)
        }
    }
    
    func setmapType(type: MapType) {
        switch type {
        case .standard:
            mapView.mapType = .standard
        case .satellite:
            mapView.mapType = .satellite
        case .hybrid:
            mapView.mapType = .hybrid
        }
    }
    
    //MARK: - Callback Methods
    
    func optionsCallbacks(_ dvc: optionsVC) {
        dvc.mapTypeUpdate = {
            self.setmapType(type: AppPreferences.shared.mapType)
        }
        
        dvc.locationUpdate = {
            self.displayLocation()
        }
        
        dvc.continuousUpdates = { enabled in
            self.updateLocation()
        }
    }
	
	//MARK: - IBActions
	
	@IBAction func updateLocation() {
		if AppPreferences.shared.continuousUpdates {
            if locController.isUpdating {
                locController.stopLocationUpdates()
                locationButton.setState(state: .continuousOFF)
            }
            else {
                locController.startLocationUpdates()
                locationButton.setState(state: .continuousON)
            }
		}
		else {
            locController.getCurrentLocation()
            locationButton.setState(state: .standard)
		}
	}
	
	@IBAction func getLocationAtTouchPoint(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            mapView.removeAnnotations((mapView?.annotations)!)
            
            let touchPoint = longPress?.location(in: mapView)
            locController.location.touchToLocation(touchPoint: touchPoint!, sender: mapView!)
            
            Task(priority: .medium) {
                if let annotation = await Annotator.displayAnnotation(self.locController.location.currentLocation, userSelected: true) {
                    mapView.addAnnotation(annotation)
                }
            }
        }
	}
}

extension mapVC: MapDelegate {
	
	//MARK: - Location Display
	
	func displayLocation() {
		mapView.removeAnnotations(mapView.annotations)
		
		RegionManager.getRegion(locationRegion: locController.location.currentLocation!, sender: mapView)
		
		if !AppPreferences.shared.continuousUpdates {
            Task(priority: .medium) {
                if let annotation = await Annotator.displayAnnotation(locController.location.currentLocation, userSelected: false) {
                    mapView.addAnnotation(annotation)
                }
            }
		}
	}
	
	//MARK: - Display Error Alert
	func locationErrorWithDeviceService(enabled: Bool) {
		var title: String?
		var message: String?
		
		if enabled {
			title = "Location permissions"
			message = "You have denied location services for this app."
		}
		else {
			title = "Location services"
			message = "You have disabled or restricted location services on your device."
		}
		
		let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
		let okbutton = UIAlertAction.init(title: "OK", style: .default, handler: nil)
		alert.addAction(okbutton)
		
		self.present(alert, animated: true, completion:nil)
	}
}
