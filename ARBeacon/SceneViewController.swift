//
//  SceneViewController.swift
//  ARBeacon
//
//  Created by InfyMac on 20/03/18.
//  Copyright © 2018 InfyMac. All rights reserved.
//

import UIKit
import ARKit

class SceneViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    var boxNode1 : SCNNode!
    var boxNode2 : SCNNode!
    var boxNode3 : SCNNode!
    var boxNode4 : SCNNode!
    var expandedBox : SCNBox!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addBox()
        addTap()
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
        box.materials = [imageToBox1, imageToBox1, imageToBox1, imageToBox1, imageToBox1, imageToBox1]
        boxNode1 = SCNNode(geometry: box)
        boxNode1.position = SCNVector3(0,-0.4,-2)
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
        box2.materials = [imageToBox2, imageToBox2, imageToBox2, imageToBox2, imageToBox2, imageToBox2]
        boxNode2 = SCNNode(geometry: box2)
        boxNode2.position = SCNVector3(0.8,0,-2)
        sceneView.pointOfView?.addChildNode(boxNode2)
        
        let box3 = SCNBox(width: 0.4, height: 0.4, length: 0.15, chamferRadius: 0.0)
        let imageToBox3 = SCNMaterial()
        //imageToBox3.isDoubleSided = true
        let imageDisplay3 = UIImage(named: "Top")
        imageToBox3.diffuse.contents = imageDisplay3
        box3.materials = [imageToBox3, imageToBox3, imageToBox3, imageToBox3, imageToBox3, imageToBox3]
        boxNode3 = SCNNode(geometry: box3)
        boxNode3.position = SCNVector3(-0.8,0,-2)
        sceneView.pointOfView?.addChildNode(boxNode3)

        let box4 = SCNBox(width: 0.4, height: 0.4, length: 0.15, chamferRadius: 0.0)
        let imageToBox4 = SCNMaterial()
        //imageToBox4.isDoubleSided = true
        let imageDisplay4 = UIImage(named: "BottomNew")
        imageToBox4.diffuse.contents = imageDisplay4
        box4.materials = [imageToBox4, imageToBox4, imageToBox4, imageToBox4, imageToBox4, imageToBox4]
        boxNode4 = SCNNode(geometry: box4)
        boxNode4.position = SCNVector3(0.0,0.4,-2.0)
        sceneView.pointOfView?.addChildNode(boxNode4)
        
        
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true

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
            
            if let exBox = expandedBox {
                exBox.height = 0.4
                exBox.width = 0.4
            }
            SCNTransaction.commit()
            
            expandedBox = derivedBox
            
        }
    }

}
