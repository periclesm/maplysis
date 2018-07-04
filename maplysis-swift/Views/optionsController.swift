//
//  optionsController.swift
//  maplysis-swift
//
//  Created by Pericles Maravelakis on 02/07/2017.
//	periclesm@cloudfields.net
//	Licensed under Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)
//	https://creativecommons.org/licenses/by-sa/4.0/
//

import UIKit

enum MapTypeEnum: Int {
	case map = 0
	case satellite = 1
	case hybrid = 2
}

class optionsController: UITableViewController {
	
	@IBOutlet var contLocSwitch: UISwitch!
	@IBOutlet var mZoomProgress: UISlider!
	@IBOutlet var mapTypeSegm: UISegmentedControl!
	@IBOutlet var geocoderSegm: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		contLocSwitch.isOn = UserDefaults.standard.bool(forKey: "ContiniousLocation")
		mZoomProgress.value = UserDefaults.standard.float(forKey: "MapZoomLevel")
		mapTypeSegm.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "MapType")
		geocoderSegm.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "Geocoder")
    }
	
	//MARK: - IBActions
	
	@IBAction func CloseAction() {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func SetContiniousUpdating() {
		UserDefaults.standard.set(contLocSwitch.isOn, forKey: "ContiniousLocation")
		UserDefaults.standard.synchronize()
	}
	
	@IBAction func SetMapZoomLevel() {
		UserDefaults.standard.set(mZoomProgress.value, forKey: "MapZoomLevel")
		UserDefaults.standard.synchronize()
	}
	
	@IBAction func SetMapType() {
		UserDefaults.standard.set(mapTypeSegm.selectedSegmentIndex, forKey: "MapType")
		UserDefaults.standard.synchronize()
	}
	
	@IBAction func SetGeocoder() {
		UserDefaults.standard.set(geocoderSegm.selectedSegmentIndex, forKey: "Geocoder")
		UserDefaults.standard.synchronize()
	}
}
