//
//  ARSCNViewViewController.swift
//  ARPlaneDetectionDemo
//
//  Created by lichanglai on 2018/4/7.
//  Copyright © 2018年 sankai. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

//pragma mark -- ARSessionDelegate
extension ARSCNViewViewController : ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        print("update camera")
    }
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        print("add anchors")
    }
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        print("update anchors")
    }
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        print("remove anchors")
    }
}
//pragma mark -- ARSCNViewDelegate
extension ARSCNViewViewController : ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor.isMember(of: ARPlaneAnchor.classForCoder()) {
            print("detection plane")
            if let planeAnchor = anchor as? ARPlaneAnchor {
                let plane = SCNBox.init(width: 0, height: CGFloat(planeAnchor.extent.y*0.3), length: CGFloat(planeAnchor.extent.x*0.3), chamferRadius: 0)
                plane.firstMaterial?.diffuse.contents = UIColor.red
                let planeNode = SCNNode.init(geometry: plane)
                planeNode.position = SCNVector3.init(planeAnchor.center.x, 0, planeAnchor.center.z)
                node.addChildNode(planeNode)
                
                let time: TimeInterval = 1.0
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                    //code
                    print("1 秒后输出")
                    let scene = SCNScene.init(named: "Models.scnassets/vase/vase.scn")
                    let vaseNode = scene?.rootNode.childNodes[0]
                    vaseNode?.position = SCNVector3.init(0, planeAnchor.center.y, planeAnchor.center.z)
                    node.addChildNode(vaseNode!)
                }
            }
        }
    }
    func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {
        print("will update")
    }
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        print("did update")
    }
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        print("did remove")
    }
}
class ARSCNViewViewController: UIViewController {
    lazy var arSCNView: ARSCNView = {
        let scnViewTmp = ARSCNView(frame: view.bounds)
        scnViewTmp.delegate = self
        scnViewTmp.session = arSession
        scnViewTmp.automaticallyUpdatesLighting = true
        return scnViewTmp
    }()
    lazy var arSession: ARSession = {
        let sessionTmp = ARSession()
        sessionTmp.delegate = self
        return sessionTmp
    }()
    lazy var arSessionConfiguration: ARWorldTrackingConfiguration = {
        let sessionConfigurationTmp = ARWorldTrackingConfiguration()
        sessionConfigurationTmp.planeDetection = ARWorldTrackingConfiguration.PlaneDetection.vertical
        sessionConfigurationTmp.isLightEstimationEnabled = true
        return sessionConfigurationTmp
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.addSubview(arSCNView)
        arSession.run(arSessionConfiguration, options: ARSession.RunOptions.removeExistingAnchors)
        
        let backBtn = UIButton.init(type: .custom)
        backBtn.setTitle("back", for: .normal)
        backBtn.frame = CGRect(x:view.bounds.size.width/2-50, y:view.bounds.size.height-100, width:100, height:50)
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        view.addSubview(backBtn)
    }
    @objc private func backAction() {
        dismiss(animated: true) {
            print("\(#function) in \(#file)")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
