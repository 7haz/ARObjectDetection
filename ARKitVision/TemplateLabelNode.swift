/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Instantiates styled label nodes based on a template node in a scene file.
*/

import SpriteKit

/// - Tag: TemplateLabelNode
class TemplateLabelNode: SKReferenceNode {
    
    private let text: String
    private var parts = ["2203031060":"Throttle body","4721735201":"Braker pump master cylinder","4436060320":"Power Steering Reservoir","2220430010":"Air Mass Sensor","9091902256":"Ignition Coil","8211135A90":"Fuse Box","7774035531":"Fuel Canister","9C3Z8101B":"Coolant Recovery Tank","4720109210":"Master Cylinder","EP5Z6766A":"Oil Filter Cap","DA8Z14300BA":"Starter Battery / Cable","8A5Z17618A":"Windshield Washer Fluid Reservoir","281551922229":"Air Filter Box","7T4Z12029DA":"Ignition Coil","182971887260":"Power Steering Pump"]

    init(text: String) {
        if let value = self.parts[text] {
            self.text = value
        }else{
            self.text = text
        }
        
        // Force call to designated init(fileNamed: String?), not convenience init(fileNamed: String)
        super.init(fileNamed: Optional.some("LabelScene"))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didLoad(_ node: SKNode?) {
        // Apply text to both labels loaded from the template.
        guard let parent = node?.childNode(withName: "LabelNode") else {
            fatalError("misconfigured SpriteKit template file")
        }
        for case let label as SKLabelNode in parent.children {
            label.name = text
            label.text = text
        }
    }
}
