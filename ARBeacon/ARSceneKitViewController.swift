//
//  ARSceneKitViewController.swift
//  ARBeacon
//
//  Created by InfyMac on 14/03/18.
//  Copyright © 2018 InfyMac. All rights reserved.
//

import UIKit
import ARKit

class ARSceneKitViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    var boxNode : SCNNode!
    var currentAngle: Float = 0.0
    var lastWidthRatio: Float = 0
    var lastHeightRatio: Float = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addBox()
        addTap()
    }
    
    struct cc {
        var x = Float()
        var y = Float()
        var z = Float()
    }
    
    func getCameraCoord(scene:ARSCNView) -> cc {
        let cameraTransform = scene.session.currentFrame?.camera.transform
        let cameraCoord = MDLTransform(matrix: cameraTransform!)
        
        var ccinst = cc()
        ccinst.x = cameraCoord.translation.x
        ccinst.y = cameraCoord.translation.y
        ccinst.z = cameraCoord.translation.z

        return ccinst
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
    
    //MARK: ARKIT specific methods to add object
    func addBox() -> Void {
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.15, chamferRadius: 0.0)
        let imageToBox1 = SCNMaterial()
        let imageToBox2 = SCNMaterial()
        let imageToBox3 = SCNMaterial()
        let imageToBox4 = SCNMaterial()
        let imageToBox5 = SCNMaterial()
        let imageToBox6 = SCNMaterial()

        let imageDisplay1 = UIImage(named: "rewards")
        let imageDisplay2 = UIImage(named: "arimg")
        let imageDisplay3 = UIImage(named: "iosimage")
        let textDisplay = "Offers & Promotions - \n\nRewards is a loyalty program available via a mobile app, that can be downloaded for Android or iPhone. Collect and redeem points."
        let imageDisplay5 = UIImage(named: "Top")
        let imageDisplay6 = UIImage(named: "Bottom")

        imageToBox1.diffuse.contents = imageDisplay1
        imageToBox2.diffuse.contents = imageDisplay2
        imageToBox3.diffuse.contents = imageDisplay3
        imageToBox5.diffuse.contents = imageDisplay5
        imageToBox6.diffuse.contents = imageDisplay6


        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: 200*UIScreen.main.scale, height: 200*UIScreen.main.scale)
        
        let textLayer = CATextLayer()
        textLayer.frame = layer.bounds
        textLayer.fontSize = 20.0
        textLayer.string = textDisplay
        textLayer.alignmentMode = kCAAlignmentLeft
        textLayer.isWrapped = true
        textLayer.backgroundColor = UIColor.white.cgColor
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.display()
        layer.addSublayer(textLayer)
        
        imageToBox4.diffuse.contents = layer

        
        box.firstMaterial?.locksAmbientWithDiffuse = true
        box.firstMaterial?.diffuse.contents = layer

        box.materials = [imageToBox6,imageToBox1,imageToBox2,imageToBox4,imageToBox5,imageToBox1]
        boxNode = SCNNode(geometry: box)
        boxNode.position = SCNVector3(0,0,-0.3)
        
        /*let text = SCNText(string: "Zoom or Rotate", extrusionDepth: 1)
        let textmaterial = SCNMaterial()
        textmaterial.diffuse.contents = text
        let textNode = SCNNode(geometry: text)
        textNode.position = SCNVector3(0, -0.1, -0.5)*/
        //sceneView.scene.rootNode.addChildNode(textNode)
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        sceneView.scene.rootNode.addChildNode(boxNode)
    }
    //MARK: scene tapped events
    func addTap() -> Void {
       
        let gestureRec = UIPanGestureRecognizer(target: self, action: #selector(sceneTapped(sender:)))
        sceneView.addGestureRecognizer(gestureRec)
        
    }
    
    @objc func sceneTapped(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: sender.view!)
        
        let transx = Float(translation.x)
        let transy = Float(-translation.y)
        let anglePan = sqrt(pow(transx,2)+pow(transy,2))*(Float)(Double.pi)/180.0
        var rotVector = SCNVector4()
        
        rotVector.x = -transy
        rotVector.y = transx
        rotVector.z = 0
        rotVector.w = anglePan
        
        boxNode.rotation = rotVector


        /* let action = SCNAction.rotateBy(x: 0, y: CGFloat(GLKMathDegreesToRadians(90)), z: 0, duration: 0.5)

        boxNode.runAction(action)
        
        //repositoning of the x,y,z axes after the rotation has been applied
        let currentPivot = boxNode.pivot
        let changePivot = SCNMatrix4Invert(boxNode.transform)
        boxNode.pivot = SCNMatrix4Mult(changePivot, currentPivot)
        boxNode.transform = SCNMatrix4Identity*/
        

        // apply to your model container node
        
        //if sender.state == .began || sender.state == .changed {
        
        
       /* let translation = sender.translation(in: sender.view!)
        var newAngle = (Float)(translation.x)*(Float)(Double.pi)/180.0
        newAngle += currentAngle
        
        boxNode.transform = SCNMatrix4MakeRotation(newAngle, 0, 1, 0)
        
        if(sender.state == UIGestureRecognizerState.ended) {
            currentAngle = newAngle
        }*/
        
        
        //}
        /*if(sender.state == UIGestureRecognizerState.ended) {
            let currentPivot = boxNode.pivot
            let changePivot = SCNMatrix4Invert(boxNode.transform)
            boxNode.pivot = SCNMatrix4Mult(changePivot, currentPivot)
            boxNode.transform = SCNMatrix4Identity
        }*/
        
        
        
    }

    @objc func pinchGesture(gestureRecognizer: UIPinchGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            gestureRecognizer.view?.transform = (gestureRecognizer.view?.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale))!
            gestureRecognizer.scale = 1.0
    }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
