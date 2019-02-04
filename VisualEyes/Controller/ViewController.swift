//
//  ViewController.swift
//  VisualEyes
//
//  Created by Alex Zhang on 2019-02-03.
//  Copyright © 2019 Alex Zhang. All rights reserved.
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
    @IBOutlet weak var analysisButton: UIButton!
    
    let phoneWidth = 834 * 3;
    let phoneHeight = 1112 * 3;
    var m_data : [UInt8] = [UInt8](repeating: 0, count: 834*3 * 1112*3)
    let azureURL: String = Constants.Azure.AZUREURL
    var faceNode: SCNNode = SCNNode()
    var testlink: String = "https://cdn.images.express.co.uk/img/dynamic/galleries/x701/389530.jpg"
    var userDataModel = UserData()
    
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
    
    // actual physical size of iPhoneX screen
    let phoneScreenSize = CGSize(width: 0.178, height: 0.247)
    
    // actual point size of iPhoneX screen
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
        navigationController?.delegate = self
        initializeDesigns()
        webView.load(URLRequest(url: URL(string: Constants.BestBuy.ONLINESTOREURL)!))
        
        // Setup Design Elements
        eyePositionIndicatorView.layer.cornerRadius = eyePositionIndicatorView.bounds.width / 2
        sceneView.layer.cornerRadius = 28
        eyePositionIndicatorCenterView.layer.cornerRadius = 4
        
        blurBarView.layer.cornerRadius = 36
        blurBarView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        webView.layer.cornerRadius = 16
        webView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
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
        analysisButton.layer.cornerRadius = 5
        analysisButton.layer.borderWidth = 1
        
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
        
        
        let heightCompensation: CGFloat = 312
        
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
            
            // Add the latest position and keep up to 8 recent position to smooth with.
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
        snapShotCurrentUserFace()
    }
    
    func snapShotCurrentUserFace() {
        let image = self.sceneView.snapshot()
        print(image)
        uiImagetoURL(image: image)
    }
    
    
    func uiImagetoURL (image: UIImage) {
        let imageData = image.jpegData(compressionQuality: 0.8)
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent("tempImage.jpg")
        print(fileURL)
        try? imageData?.write(to: fileURL, options: [])
        
        getImageData(url1: fileURL)
    }
    
    func getImageData(url1: URL) {
        //        let config = CLDConfiguration(cloudName: "CLOUD_NAME", secure: "true")
        //        let cloudinary = CLDCloudinary(configuration: config)
        var downloadURL1: URL?
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let mountainsRef = storageRef.child("images/mountains.jpg")
        let localFile = url1
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        // Upload file and metadata
        let uploadTask = mountainsRef.putFile(from: localFile, metadata: nil) { metadata, error in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                print(error.debugDescription)
                return
                
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            
            // You can also access to download URL after upload.
            mountainsRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    print(error.debugDescription)
                    
                    return
                }
                print("====download url of the image============line 274")
                print(downloadURL)
                downloadURL1 = downloadURL
                
                
                let headers: HTTPHeaders = [
                    "Content-Type" : "application/json",
                    "Ocp-Apim-Subscription-Key": Constants.Azure.SUBSCRIPTIONKEY,
                    ]
                print(downloadURL1?.absoluteString)
                //some parameters included in Constants.Azure.AZUREURL
                let parameters: Parameters = [
                    //            "returnFaceId":true,
                    //            "returnFaceLandmarks": false,
                    //            "returnFaceAttributes": "age, gender, emotion, hair, makeup, occlusion, accessories, blur",
                    "url" : downloadURL1?.absoluteString
                ]
                
                Alamofire.request(self.azureURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                    if response.result.isSuccess {
                        print("successfully get JSON data!")
                        let jso: JSON = JSON(response.result.value!)
                        //print out the returned json for testing
                        print(jso)
                        self.updateUserData(json: jso)
                    }else{
                        print("fail to get JSON response!")
                        DispatchQueue.main.async {
                            self.navigationItem.title = "Fail to get image infomation"
                        }
                    }
                }
            }
        }
    }
    
    func updateUserData (json: JSON) {
        self.userDataModel.age = json[0]["faceAttributes"]["age"].intValue
        self.userDataModel.gender = json[0]["faceAttributes"]["gender"].stringValue
        self.userDataModel.neutral = json[0]["faceAttributes"]["emotion"]["neutral"].doubleValue
        self.userDataModel.happiness = json[0]["faceAttributes"]["emotion"]["happiness"].doubleValue
        self.userDataModel.anger = json[0]["faceAttributes"]["emotion"]["anger"].doubleValue
        self.userDataModel.disgust = json[0]["faceAttributes"]["emotion"]["disgust"].doubleValue
        self.userDataModel.fear = json[0]["faceAttributes"]["emotion"]["fear"].doubleValue
        self.userDataModel.sadness = json[0]["faceAttributes"]["emotion"]["sadness"].doubleValue
        self.userDataModel.contempt = json[0]["faceAttributes"]["emotion"]["contempt"].doubleValue
        self.userDataModel.surprise = json[0]["faceAttributes"]["emotion"]["surprise"].doubleValue
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toData") {
            print("find seggg!!!!!!!!!!!!!!!!!")
            let destinationVC = segue.destination as! DataViewController
            destinationVC.userDataD = userDataModel
            print("set seggg!!!!!!!!!!!!!!!!!")
        }
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        virtualPhoneNode.transform = (sceneView.pointOfView?.transform)!
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        faceNode.transform = node.transform
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        update(withFaceAnchor: faceAnchor)
    }
    
}
