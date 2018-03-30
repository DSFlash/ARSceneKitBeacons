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
import UserNotifications

class SceneViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var boxNode1 : SCNNode!
    var boxNode2 : SCNNode!
    var boxNode3 : SCNNode!
    var boxNode4 : SCNNode!
    var expandedBox : SCNBox!
    var locationManager : CLLocationManager!
    var isMonitoring : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        //Start Monitoring and ranging beacons
        startRangingBeacons()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //create configuration session
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //pause configuration session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: ARKIT specific methods to add objects to the scene
    func addBox() -> Void {
        
        let box = SCNBox(width: 0.4, height: 0.4, length: 0.4, chamferRadius: 0.0)
        let imageToBox1 = SCNMaterial()
        let imageDisplay1 = UIImage(named: "Bottom")
        imageToBox1.diffuse.contents = imageDisplay1
        box.materials = [imageToBox1]
        box.name = "Bottom"
        boxNode1 = SCNNode(geometry: box)
        boxNode1.position = SCNVector3(0,-0.8,-2)

        sceneView.pointOfView?.addChildNode(boxNode1)
        
        let box2 = SCNBox(width: 0.4, height: 0.4, length: 0.4, chamferRadius: 0.0)
        let imageToBox2 = SCNMaterial()
        let imageDisplay2 = UIImage(named: "Right")
        imageToBox2.diffuse.contents = imageDisplay2
        box2.materials = [imageToBox2]
        box2.name = "Right"
        boxNode2 = SCNNode(geometry: box2)
        boxNode2.position = SCNVector3(1.0,0,-2)
        sceneView.pointOfView?.addChildNode(boxNode2)
        
        let box3 = SCNBox(width: 0.4, height: 0.4, length: 0.4, chamferRadius: 0.0)
        let imageToBox3 = SCNMaterial()
        let imageDisplay3 = UIImage(named: "Left")
        imageToBox3.diffuse.contents = imageDisplay3
        box3.materials = [imageToBox3]
        box3.name = "Left"
        boxNode3 = SCNNode(geometry: box3)
        boxNode3.position = SCNVector3(-1.0,0,-2)
        sceneView.pointOfView?.addChildNode(boxNode3)
        
        let box4 = SCNBox(width: 0.4, height: 0.4, length: 0.4, chamferRadius: 0.0)
        let imageToBox4 = SCNMaterial()
        let imageDisplay4 = UIImage(named: "Top")
        imageToBox4.diffuse.contents = imageDisplay4
        box4.materials = [imageToBox4]
        box4.name = "TopImage"
        
        boxNode4 = SCNNode(geometry: box4)
        boxNode4.position = SCNVector3(0.0,0.8,-2.0)
        boxNode4.name = "TopImage"
        sceneView.pointOfView?.addChildNode(boxNode4)
        
        //animate the nodes
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 3
        boxNode1.position = SCNVector3(0,-0.4,-2)
        boxNode2.position = SCNVector3(0.8,0,-2)
        boxNode3.position = SCNVector3(-0.8,0,-2)
        boxNode4.position = SCNVector3(0.0,0.3,-2.0)
        SCNTransaction.commit()
        
        /*sceneView.autoenablesDefaultLighting = true
         sceneView.allowsCameraControl = true*/
        
    }
    
    //MARK: - Location manager Delegate methods
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            let beaconSelected = beacons[0]
            switch beaconSelected.proximity {
            case .near, .immediate, .far:
                print("beacon region")
                //stop ranging beacons once detected
                locationManager.stopRangingBeacons(in: region)
                
                //Add Box, handle nodes tap and rotation
                addBox()
                addTap()
                addTapToRotate()
                
            case .unknown:
                print("unknown")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("entered beacon region")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("exited beacon region")
        
        //On exiting the beacon range, remove the added nodes from scene
        removeExistingNodesOutOfRegion()
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
        //Specific UUID, Major, Minor has been given here - which the app is looking for
        let UUIDparam = UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")
        let regionBeacon = CLBeaconRegion(proximityUUID: UUIDparam!, major: 1001, minor: 1, identifier: "B9407F30")
        
        locationManager.startMonitoring(for: regionBeacon)
        locationManager.startRangingBeacons(in: regionBeacon)
        
    }
    
    func removeExistingNodesOutOfRegion() -> Void {
        if boxNode4 != nil && boxNode3 != nil && boxNode2 != nil && boxNode1 != nil {
            boxNode1.removeFromParentNode()
            boxNode2.removeFromParentNode()
            boxNode3.removeFromParentNode()
            boxNode4.removeFromParentNode()
        }
    }
    
    //MARK: - Scene Tapped methods
    //scene tapped events
    func addTap() -> Void {
        
        let gestureRec = UITapGestureRecognizer(target: self, action: #selector(sceneTapped(sender:)))
        sceneView.addGestureRecognizer(gestureRec)
        
    }
    
    //scene tapped events to rotate
    func addTapToRotate() -> Void {
        
        let gestureToRotate = UIPanGestureRecognizer(target: self, action: #selector(sceneTappedToRotate(sender:)))
        sceneView.addGestureRecognizer(gestureToRotate)
        
    }
    
    @objc func sceneTappedToRotate(sender: UIPanGestureRecognizer) {
        let sceneView = sender.view as! SCNView
        let tapLoc = sender.location(in: sceneView)
        let hitResults = sceneView.hitTest(tapLoc, options: [:])
        if hitResults.count > 0 {
            let translation = sender.translation(in: sender.view!)
            
            let transx = Float(translation.x)
            let transy = Float(-translation.y)
            let anglePan = sqrt(pow(transx,2)+pow(transy,2))*(Float)(Double.pi)/180.0
            var rotVector = SCNVector4()
            
            rotVector.x = -transy
            rotVector.y = transx
            rotVector.z = 0
            rotVector.w = anglePan
            
            let tapped = hitResults[0]
            let tappedNode = tapped.node
            tappedNode.rotation = rotVector
        }
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
            derivedBox.length = 0.8
            
            //display the front of the node even if rotated while expanding or collapsing
            tappedNode.rotation = SCNVector4Make(0, 0, 0, 0)
            
            if tappedNode.name == "TopImage" {
                tappedNode.position.y = 0.2
            }
            else if tappedNode.name == "Bottom" {
                tappedNode.position.y = -0.2
            }
            
            //minimize the box
            if let exBox = expandedBox {
                exBox.height = 0.4
                exBox.width = 0.4
                exBox.length = 0.4
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
}
