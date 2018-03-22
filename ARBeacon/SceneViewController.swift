//
//  SceneViewController.swift
//  ARBeacon
//
//  Created by InfyMac on 20/03/18.
//  Copyright © 2018 InfyMac. All rights reserved.
//

import UIKit
import ARKit
import CoreLocation


class SceneViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var boxNode1 : SCNNode!
    var boxNode2 : SCNNode!
    var boxNode3 : SCNNode!
    var boxNode4 : SCNNode!
    var expandedBox : SCNBox!
    var locationManager : CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        // Do any additional setup after loading the view.
        //addBox()
        //addTap()
        startRangingBeacons()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: ARKIT specific methods to add objects
    func addBox() -> Void {
        let box = SCNBox(width: 0.4, height: 0.4, length: 0.15, chamferRadius: 0.0)
        let imageToBox1 = SCNMaterial()
        //imageToBox1.isDoubleSided = true
        let imageDisplay1 = UIImage(named: "Pamp")
        imageToBox1.diffuse.contents = imageDisplay1
        box.materials = [imageToBox1]
        box.name = "Pamp"
        boxNode1 = SCNNode(geometry: box)
        boxNode1.position = SCNVector3(0,-0.8,-2)
        let physicsBody = SCNPhysicsBody(
            type: .kinematic,
            shape: SCNPhysicsShape(geometry: SCNSphere(radius: 0.1))
        )
        boxNode1.physicsBody = physicsBody
        sceneView.pointOfView?.addChildNode(boxNode1)


        let box2 = SCNBox(width: 0.4, height: 0.4, length: 0.15, chamferRadius: 0.0)
        let imageToBox2 = SCNMaterial()
        let imageDisplay2 = UIImage(named: "Bottom")
        //imageToBox2.isDoubleSided = true
        imageToBox2.diffuse.contents = imageDisplay2
        box2.materials = [imageToBox2]
        box2.name = "Bottom"
        boxNode2 = SCNNode(geometry: box2)
        boxNode2.position = SCNVector3(1.0,0,-2)
        sceneView.pointOfView?.addChildNode(boxNode2)
        
        let box3 = SCNBox(width: 0.4, height: 0.4, length: 0.15, chamferRadius: 0.0)
        let imageToBox3 = SCNMaterial()
        let imageDisplay3 = UIImage(named: "Top")
        imageToBox3.diffuse.contents = imageDisplay3
        box3.materials = [imageToBox3]
        box3.name = "Top"
        boxNode3 = SCNNode(geometry: box3)
        boxNode3.position = SCNVector3(-1.0,0,-2)
        sceneView.pointOfView?.addChildNode(boxNode3)

        let box4 = SCNBox(width: 0.4, height: 0.4, length: 0.15, chamferRadius: 0.0)
        let imageToBox4 = SCNMaterial()
        //imageToBox4.isDoubleSided = true
        let imageDisplay4 = UIImage(named: "BottomNew")
        imageToBox4.diffuse.contents = imageDisplay4
        box4.materials = [imageToBox4]
        box4.name = "TopImage"

        boxNode4 = SCNNode(geometry: box4)
        boxNode4.position = SCNVector3(0.0,0.8,-2.0)
        boxNode4.name = "TopImage"
        sceneView.pointOfView?.addChildNode(boxNode4)

        SCNTransaction.begin()
        SCNTransaction.animationDuration = 3
        boxNode1.position = SCNVector3(0,-0.4,-2)
        boxNode2.position = SCNVector3(0.8,0,-2)
        boxNode3.position = SCNVector3(-0.8,0,-2)
        boxNode4.position = SCNVector3(0.0,0.3,-2.0)

        SCNTransaction.commit()
        
//        UIView.animate(withDuration: 2.0, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: {
//            self.sceneView.pointOfView?.addChildNode(self.boxNode1)
//            self.sceneView.pointOfView?.addChildNode(self.boxNode2)
//            self.sceneView.pointOfView?.addChildNode(self.boxNode3)
//            self.sceneView.pointOfView?.addChildNode(self.boxNode4)
//
//        }, completion: nil)

        
        //sceneView.autoenablesDefaultLighting = true
        //sceneView.allowsCameraControl = true

    }
    
    //MARK: scene tapped events
    func addTap() -> Void {
        
        let gestureRec = UITapGestureRecognizer(target: self, action: #selector(sceneTapped(sender:)))
        sceneView.addGestureRecognizer(gestureRec)
        
    }
    
    @objc func sceneTapped(sender:UIGestureRecognizer) {
        let sceneView = sender.view as! SCNView
        let tapLoc = sender.location(in: sceneView)
        let hitResults = sceneView.hitTest(tapLoc, options: [:])
        
        if hitResults.count > 0 {
            let tapped = hitResults[0]
            let tappedNode = tapped.node

            SCNTransaction.begin()
            SCNTransaction.animationDuration = 2
            let derivedBox:SCNBox = tappedNode.geometry as! SCNBox
            derivedBox.height = 0.8
            derivedBox.width = 0.8
            
            //tappedNode.pivot = SCNMatrix4MakeTranslation(0, -Float(derivedBox.height/2), 0) // new height
            if tappedNode.name == "TopImage" {
                tappedNode.position.y = 0.2
            }
            else if tappedNode.name == "Pamp" {
                tappedNode.position.y = -0.2
            }
            
            if let exBox = expandedBox {
                    exBox.height = 0.4
                    exBox.width = 0.4
            }
            SCNTransaction.commit()
            
            if expandedBox == derivedBox {
                expandedBox = nil
            }
            else {
                expandedBox = derivedBox
            }
            
        }
    }
    
    //MARK: - Localtion manager Delegate methods
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            let beaconSelected = beacons[0]
            switch beaconSelected.proximity {
            case .near, .immediate, .far:
                //status.text = "Near Beacon - Opening Scene"
                //self.view.backgroundColor = UIColor.darkGray
                print("beacon region")
                locationManager.stopRangingBeacons(in: region)

                addBox()
                addTap()
                
                /*DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    //self.performSegue(withIdentifier: "arscenekit", sender: self)
                    self.performSegue(withIdentifier: "sceneVC", sender: self)
                    //self.status.text = "Stopped ranging"
                }*/
                
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
   /* @IBAction func startRanging(_ sender: Any) {
        startRangingBeacons()
    }*/
    
    
}
