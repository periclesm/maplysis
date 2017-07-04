//
//  AppDelegate.swift
//  maplysis-swift
//
//  Created by Pericles Maravelakis on 02/07/2017.
//	periclesm@cloudfields.net
//	Licensed under Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)
//	https://creativecommons.org/licenses/by-sa/4.0/
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		let defaults = UserDefaults.standard
		
		if defaults.object(forKey: "ContiniousLocation") == nil {
			defaults.set(false, forKey: "ContiniousLocation")
		}
		
		if defaults.object(forKey: "Geocoder") == nil {
			defaults.set(0, forKey: "Geocoder")
		}
		
		if defaults.object(forKey: "MapZoomLevel") == nil {
			defaults.set(300, forKey: "MapZoomLevel")
		}
		
		if defaults.object(forKey: "MapType") == nil {
			defaults.set(0, forKey: "MapType")
		}
		
		return true
	}

}

