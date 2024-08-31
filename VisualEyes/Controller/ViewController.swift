//
//  ViewController.swift
//  VisualEyes
//  Copyright © 2024 Alex Zhang. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import WebKit
import Alamofire
import SwiftyJSON
import Firebase
import FirebaseStorage

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var eyePositionIndicatorView: UIView!
    @IBOutlet weak var eyePositionIndicatorCenterView: UIView!
    @IBOutlet weak var blurBarView: UIVisualEffectView!
    @IBOutlet weak var lookAtPositionXLabel: UILabel!
    @IBOutlet weak var lookAtPositionYLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var analysisButton: UIButton!
    
    let azureURL: String = Constants.Azure.AZUREURL
    var faceNode: SCNNode = SCNNode()
    var testlink: String = "https://cdn.images.express.co.uk/img/dynamic/galleries/x701/389530.jpg"
    
    // create an userDataModel instance for uploading to firebase
    var userDataModel = UserData()
    
    var startInt = 4
    
    var sessionInt = 10
    
    //timer for time indicator
    var analysisButtonPressed: Bool = false
    var clockUpdateTime: TimeInterval = 0
    
    //timer for running the analysis session
    var analysisSessionRunning: Bool = false
    var analysisPerformTime: TimeInterval = 0
    
    
    var eyeLNode: SCNNode = {
        let geometry = SCNCone(topRadius: 0.005, bottomRadius: 0, height: 0.2)
        geometry.radialSegmentCount = 3
        geometry.firstMaterial?.diffuse.contents = UIColor.blue
        let node = SCNNode()
        node.geometry = geometry
        node.eulerAngles.x = -.pi / 2
        node.position.z = 0.1
        let parentNode = SCNNode()
        parentNode.addChildNode(node)
        return parentNode
    }()
    
    var eyeRNode: SCNNode = {
        let geometry = SCNCone(topRadius: 0.005, bottomRadius: 0, height: 0.2)
        geometry.radialSegmentCount = 3
        geometry.firstMaterial?.diffuse.contents = UIColor.blue
        let node = SCNNode()
        node.geometry = geometry
        node.eulerAngles.x = -.pi / 2
        node.position.z = 0.1
        let parentNode = SCNNode()
        parentNode.addChildNode(node)
        return parentNode
    }()
    
    var lookAtTargetEyeLNode: SCNNode = SCNNode()
    var lookAtTargetEyeRNode: SCNNode = SCNNode()
    
    // actual physical size of ipad pro 11 screen
    let phoneScreenSize = CGSize(width: 0.178, height: 0.247)
    
    // actual point size of ipad pro 11 screen
    let phoneScreenPointSize = CGSize(width: 834, height: 1112)
    
    var virtualPhoneNode: SCNNode = SCNNode()
    
    var virtualScreenNode: SCNNode = {
        
        let screenGeometry = SCNPlane(width: 1, height: 1)
        screenGeometry.firstMaterial?.isDoubleSided = true
        screenGeometry.firstMaterial?.diffuse.contents = UIColor.green
        return SCNNode(geometry: screenGeometry)
    }()
    
    var eyeLookAtPositionXs: [CGFloat] = []
    
    var eyeLookAtPositionYs: [CGFloat] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeDesigns()
        webView.load(URLRequest(url: URL(string: Constants.Microsoft.ONLINESTOREURL)!))
        
        // setup the timer
        //scheduledTimerWithTimeInterval()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        
        // Setup Scenegraph
        sceneView.scene.rootNode.addChildNode(faceNode)
        sceneView.scene.rootNode.addChildNode(virtualPhoneNode)
        virtualPhoneNode.addChildNode(virtualScreenNode)
        faceNode.addChildNode(eyeLNode)
        faceNode.addChildNode(eyeRNode)
        eyeLNode.addChildNode(lookAtTargetEyeLNode)
        eyeRNode.addChildNode(lookAtTargetEyeRNode)
        
        // Set LookAtTargetEye at 2 meters away from the center of eyeballs to create segment vector
        lookAtTargetEyeLNode.position.z = 2
        lookAtTargetEyeRNode.position.z = 2
    }
    
    func initializeDesigns() {
        // Setup Design Elements
        eyePositionIndicatorView.layer.cornerRadius = eyePositionIndicatorView.bounds.width / 2
        sceneView.layer.cornerRadius = 28
        eyePositionIndicatorCenterView.layer.cornerRadius = 4
        
        blurBarView.layer.cornerRadius = 36
        blurBarView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        webView.layer.cornerRadius = 16
        webView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        analysisButton.layer.cornerRadius = 5
        analysisButton.layer.borderWidth = 1
        analysisButton.layer.backgroundColor = UIColor(red: 93/255.0, green: 99/255.0, blue: 103/255.0, alpha: 0.8).cgColor
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        guard ARFaceTrackingConfiguration.isSupported else { return }
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        
        // Run the view's session
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        faceNode.transform = node.transform
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        update(withFaceAnchor: faceAnchor)
    }
    
    // MARK: - update(ARFaceAnchor)
    
    func update(withFaceAnchor anchor: ARFaceAnchor) {
        
        eyeRNode.simdTransform = anchor.rightEyeTransform
        eyeLNode.simdTransform = anchor.leftEyeTransform
        
        var eyeLLookAt = CGPoint()
        var eyeRLookAt = CGPoint()
        
        
        let heightCompensation: CGFloat = 614
        
        DispatchQueue.main.async {
            
            // Perform Hit test using the ray segments that are drawn by the center of the eyeballs to somewhere two meters away at direction of where users look at to the virtual plane that place at the same orientation of the phone screen
            
            let phoneScreenEyeRHitTestResults = self.virtualPhoneNode.hitTestWithSegment(from: self.lookAtTargetEyeRNode.worldPosition, to: self.eyeRNode.worldPosition, options: nil)
            
            let phoneScreenEyeLHitTestResults = self.virtualPhoneNode.hitTestWithSegment(from: self.lookAtTargetEyeLNode.worldPosition, to: self.eyeLNode.worldPosition, options: nil)
            
            for result in phoneScreenEyeRHitTestResults {
                
                eyeRLookAt.x = CGFloat(result.localCoordinates.x) / (self.phoneScreenSize.width / 2) * self.phoneScreenPointSize.width
                
                eyeRLookAt.y = CGFloat(result.localCoordinates.y) / (self.phoneScreenSize.height / 2) * self.phoneScreenPointSize.height + heightCompensation
            }
            
            for result in phoneScreenEyeLHitTestResults {
                
                eyeLLookAt.x = CGFloat(result.localCoordinates.x) / (self.phoneScreenSize.width / 2) * self.phoneScreenPointSize.width
                
                eyeLLookAt.y = CGFloat(result.localCoordinates.y) / (self.phoneScreenSize.height / 2) * self.phoneScreenPointSize.height + heightCompensation
            }
            
            // Add the latest position and keep up to 10 recent position to smooth with.
            let smoothThresholdNumber: Int = 10
            self.eyeLookAtPositionXs.append((eyeRLookAt.x + eyeLLookAt.x) / 2)
            self.eyeLookAtPositionYs.append(-(eyeRLookAt.y + eyeLLookAt.y) / 2)
            self.eyeLookAtPositionXs = Array(self.eyeLookAtPositionXs.suffix(smoothThresholdNumber))
            self.eyeLookAtPositionYs = Array(self.eyeLookAtPositionYs.suffix(smoothThresholdNumber))
            
            let smoothEyeLookAtPositionX = self.eyeLookAtPositionXs.average!
            let smoothEyeLookAtPositionY = self.eyeLookAtPositionYs.average!
            
            // update indicator position
            self.eyePositionIndicatorView.transform = CGAffineTransform(translationX: smoothEyeLookAtPositionX, y: smoothEyeLookAtPositionY)
            
            // update eye look at labels values
            self.lookAtPositionXLabel.text = "\(Int(round(smoothEyeLookAtPositionX + self.phoneScreenPointSize.width / 2)))"
            
            self.lookAtPositionYLabel.text = "\(Int(round(smoothEyeLookAtPositionY + self.phoneScreenPointSize.height / 2)))"
            
            // Calculate distance of the eyes to the camera
            let distanceL = self.eyeLNode.worldPosition - SCNVector3Zero
            let distanceR = self.eyeRNode.worldPosition - SCNVector3Zero
            
            // Average distance from two eyes
            let distance = (distanceL.length() + distanceR.length()) / 2
            
            // Update distance label value
            self.distanceLabel.text = "\(Int(round(distance * 100))) cm"
        }
    }

    
    @IBAction func buttonPressssed(_ sender: UIButton){
       analysisButton.isEnabled = false
       analysisButtonPressed = true
        
//        DispatchQueue.main.async {
//            self.startTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.startAnalysisSessionTimer), userInfo: nil, repeats: true)
//        }
        
        //snapShotCurrentUserFace()
    }
    
    
    func analyzeCurrentUser() {
        let image = self.sceneView.snapshot()
        print(image)
        //unnecessary event handeler
        //remove later
        UploadService.create(for: image, xpos: lookAtPositionXLabel.text, ypos: lookAtPositionYLabel.text) { url in
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toData") {
            print("find seggg!!!!!!!!!!!!!!!!!")
            let destinationVC = segue.destination as! DataViewController
            destinationVC.userDataD = userDataModel
            print("set seggg!!!!!!!!!!!!!!!!!")
        }
        
    }
    
    //time based logic:
    //set the postion of the vituralPhoneNode to the real-world and real-time pos of the ipad every frame (60 frames per second)
    //update the time indicator, and execute the analysis session every few seconds
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        virtualPhoneNode.transform = (sceneView.pointOfView?.transform)!
        if(analysisButtonPressed == true) {
            if(time > clockUpdateTime) {
                //update the time indicator
                //schedule the clockUpdateTime when system time is forward
                clockUpdateTime = time + TimeInterval(1)
                
                //perform countdown before the analysis session
                if(!analysisSessionRunning){
                    startInt -= 1
                    DispatchQueue.main.async {
                        self.analysisButton.setTitle(String(self.startInt), for: .normal)
                    }
                    if (startInt == 0){
                        self.analysisSessionRunning = true
                    }
                }
                
                //start the analysis session after countdown
                if (analysisSessionRunning) {
                    sessionInt -= 1
                    DispatchQueue.main.async {
                        self.analysisButton.setTitle("session running", for: .normal)
                        self.timeLabel.text = String(self.sessionInt)
                    }
                    if(sessionInt == 0) {
                        analysisSessionRunning = false
                        performSegue(withIdentifier: "goToDataViewController", sender: self)
                    }
                }
            }
            
            if (time > analysisPerformTime) {
                //It's time to perform analysis!
                //schedule the next analysis performing time, perform analysis every 5 sec for the current setting
                analysisPerformTime = time + TimeInterval(2)
                
                //take a picture of user's face and run azure face analysis, then upload result to firebase
                self.analyzeCurrentUser()
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        faceNode.transform = node.transform
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        update(withFaceAnchor: faceAnchor)
    }

    
//    Traditional timer with bugs
//    @objc func startAnalysisSessionTimer() {
//        startInt -= 1
//        analysisButton.setTitle(String(startInt), for: .normal)
//
//        if startInt == 0 {
//            startTimer.invalidate()
//            analysisButton.setTitle("Session Running", for: .normal)
//            DispatchQueue.main.async {
//                self.sessionTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.runAnalysisSession), userInfo: nil, repeats: true)
//            }
//        }
//    }
    
    //bug: timer not running when scrolling the webview
    //may fix the bug by using the renderer(update at time) method?
//    @objc func runAnalysisSession(){
//        DispatchQueue.main.async {
//            self.sessionInt -= 1
//            self.timeLabel.text = String(self.sessionInt)
//            if (self.sessionInt == 0) {
//                self.sessionTimer.invalidate()
//            }
//        }
//    }
    
}
