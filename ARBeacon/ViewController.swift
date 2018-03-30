//
//  ViewController.swift
//  ARBeacon
//
//  Created by InfyMac on 14/03/18.
//  Copyright © 2018 InfyMac. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var status: UILabel!
    var locationManager : CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()

        
        /* We are ranging beacons in Scene View Controller now
         startRangingBeacons()
        /registerNotification()*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        status.text = "No Beacons nearby"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func startRanging(_ sender: Any) {
        self.status.text = "Opening Scene"

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.performSegue(withIdentifier: "sceneVC", sender: self)
        }
        
    }
    
    func registerNotification() -> Void {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {(allowed, error) in
            if allowed {
                print("allowed local notif")
            }
            else {
                print("did not allow local notif")
            }
        })
    }
    
}

