//
//  optionsController.swift
//  maplysis-swift
//
//  Created by Pericles Maravelakis on 02/07/2017.
//	periclesm@cloudfields.net
//  Licensed under Creative Commons Attribution 4.0 International (CC BY 4.0)
//  https://creativecommons.org/licenses/by/4.0/
//

import UIKit

class optionsVC: UITableViewController {
	
	@IBOutlet weak var contLocSwitch: UISwitch!
	@IBOutlet weak var mZoomProgress: UISlider!
	@IBOutlet weak var mapTypeSegm: UISegmentedControl!
	@IBOutlet weak var geocoderSegm: UISegmentedControl!
    
    var continuousUpdates: ((Bool) -> Void)?
    var mapTypeUpdate: (() -> Void)?
    var locationUpdate: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
		
        contLocSwitch.isOn = AppPreferences.shared.continuousUpdates
        mZoomProgress.value = AppPreferences.shared.mapZoom
        mapTypeSegm.selectedSegmentIndex = AppPreferences.shared.mapType.rawValue
        geocoderSegm.selectedSegmentIndex = AppPreferences.shared.geocoder.rawValue
    }
	
	//MARK: - IBActions
	
	@IBAction func CloseAction() {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func SetContinuousUpdating() {
        AppPreferences.shared.continuousUpdates = contLocSwitch.isOn
        continuousUpdates?(contLocSwitch.isOn)
	}
	
	@IBAction func SetMapZoomLevel() {
        AppPreferences.shared.mapZoom = mZoomProgress.value
        locationUpdate?()
	}
	
	@IBAction func SetMapType() {
        AppPreferences.shared.mapType = MapType(rawValue: mapTypeSegm.selectedSegmentIndex)!
        mapTypeUpdate?()
	}
	
	@IBAction func SetGeocoder() {
        AppPreferences.shared.geocoder = GeocoderService(rawValue: geocoderSegm.selectedSegmentIndex)!
	}
}
