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

class optionsController: UITableViewController {
	
	@IBOutlet weak var contLocSwitch: UISwitch!
	@IBOutlet weak var mZoomProgress: UISlider!
	@IBOutlet weak var mapTypeSegm: UISegmentedControl!
	@IBOutlet weak var geocoderSegm: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
		
        contLocSwitch.isOn = AppPreferences.shared.continiousUpdates
        mZoomProgress.value = AppPreferences.shared.mapZoom
        mapTypeSegm.selectedSegmentIndex = AppPreferences.shared.mapType.rawValue
        geocoderSegm.selectedSegmentIndex = AppPreferences.shared.geocoder.rawValue
    }
	
	//MARK: - IBActions
	
	@IBAction func CloseAction() {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func SetContiniousUpdating() {
        AppPreferences.shared.continiousUpdates = contLocSwitch.isOn
	}
	
	@IBAction func SetMapZoomLevel() {
        AppPreferences.shared.mapZoom = mZoomProgress.value
	}
	
	@IBAction func SetMapType() {
        AppPreferences.shared.mapType = MapType(rawValue: mapTypeSegm.selectedSegmentIndex)!
	}
	
	@IBAction func SetGeocoder() {
        AppPreferences.shared.geocoder = GeocoderService(rawValue: geocoderSegm.selectedSegmentIndex)!
	}
}
