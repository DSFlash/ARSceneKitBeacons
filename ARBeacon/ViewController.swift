//
//  ViewController.swift
//  ARBeacon
//
//  Created by InfyMac on 14/03/18.
//  Copyright © 2018 InfyMac. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var status: UILabel!
    var locationManager : CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        //self.view.backgroundColor = UIColor.lightGray

        startRangingBeacons()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        status.text = "Ranging Beacon"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Localtion manager Delegate methods
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            let beaconSelected = beacons[0]
            switch beaconSelected.proximity {
            case .near, .immediate:
                status.text = "Near Beacon - Opening Camera"
                //self.view.backgroundColor = UIColor.darkGray
                print("near")
                locationManager.stopRangingBeacons(in: region)

                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    //self.performSegue(withIdentifier: "arscenekit", sender: self)
                    self.performSegue(withIdentifier: "sceneVC", sender: self)
                    self.status.text = "Stopped ranging"
                }
                
            case .unknown:
                //status.text = "No Beacons nearby"
                print("unknown")
            default:
                //status.text = "No Beacons nearby"
                print("unknown")
            }
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("entered beacon region")
//        status.text = "Entered Region - Opening Camera"
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.performSegue(withIdentifier: "arscenekit", sender: self)
//        }
//
//        let alertView = UIAlertController(title: "Enter Beacon Region", message: "", preferredStyle: .alert)
//        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//        alertView.addAction(action)
//        present(alertView, animated: true, completion: nil)
//
        //self.view.backgroundColor = UIColor.darkGray
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("exited beacon region")
        
        status.text = "No Beacons nearby"
        //self.view.backgroundColor = UIColor.lightGray
        locationManager.stopMonitoring(for: region)

    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedAlways {
        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
            if CLLocationManager.isRangingAvailable() {
                startRangingBeacons()
            }
        }
        }
    }
    
    //MARK: - methods to range beacon and act when find
    func startRangingBeacons() {
        let UUIDparam = UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")
        let regionBeacon = CLBeaconRegion(proximityUUID: UUIDparam!, major: 1001, minor: 1, identifier: "B9407F30")
        
        locationManager.startMonitoring(for: regionBeacon)
        locationManager.startRangingBeacons(in: regionBeacon)
        
    }
    @IBAction func startRanging(_ sender: Any) {
        startRangingBeacons()
    }
    
}

