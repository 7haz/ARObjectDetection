/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Instantiates styled label nodes based on a template node in a scene file.
*/

import SpriteKit

/// - Tag: TemplateLabelNode
class TemplateLabelNode: SKReferenceNode {
    //Properties
    private let part: Part?
    private var parts = ["2203031060":"Throttle body","4721735201":"Braker pump master cylinder","4436060320":"Power Steering Reservoir","2220430010":"Air Mass Sensor","9091902256":"Ignition Coil","8211135A90":"Fuse Box","7774035531":"Fuel Canister","9C3Z8101B":"Coolant Recovery Tank","4720109210":"Master Cylinder","EP5Z6766A":"Oil Filter Cap","DA8Z14300BA":"Starter Battery / Cable","8A5Z17618A":"Windshield Washer Fluid Reservoir","281551922229":"Air Filter Box","7T4Z12029DA":"Ignition Coil","182971887260":"Power Steering Pump"]
    
    //Not in use now
    private let text: String
    private let partNo: String?
    private var image: UIImage? = nil
    var rootNode : SKNode? = nil
    
    init(text: String) {
        if let value = self.parts[text] {
            self.text = value
        }else{
            self.text = text
        }
        self.part = nil
        self.image = nil
        self.partNo = nil
        // Force call to designated init(fileNamed: String?), not convenience init(fileNamed: String)
        super.init(fileNamed: Optional.some("LabelScene"))
    }
    init(part:Part?, image:UIImage?) {
        self.part = part
        self.image = image
        self.partNo = nil
        self.text = ""
        // Force call to designated init(fileNamed: String?), not convenience init(fileNamed: String)
        super.init(fileNamed: Optional.some("LabelScene"))
    }
    init(part:Part?, partNo:String?) {
        self.part = part
        self.partNo = partNo
        self.image = nil
        self.text = ""
        // Force call to designated init(fileNamed: String?), not convenience init(fileNamed: String)
        super.init(fileNamed: Optional.some("LabelScene"))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(node:SKNode?) {
        // Apply text to both labels loaded from the template.
        guard let parent = node?.childNode(withName: "LabelNode") as? SKShapeNode else {
            return
        }
        parent.fillColor = UIColor.clear
        parent.strokeColor = UIColor.clear
        parent.xScale = 0.0015
        parent.yScale = 0.0015
        for node in parent.children {
            //Labels
            if let label = node as? SKLabelNode {
                label.horizontalAlignmentMode = .left
                label.numberOfLines = 1
                label.fontColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
                label.verticalAlignmentMode = .top
                
                switch label.name! {
                case "Label1":
                    label.text = part!.title
                    print("Title: \(part!.title)")
                case "Label2":
                    label.text = "\(part!.year) \(part!.car)"
                    print("Year: \(part!.year) \(part!.car)")
                case "Label3":
                    label.text = "Price: \(part!.price)"
                    label.fontColor = UIColor.red
                case "Label4":
                    label.text = part?._id ?? self.partNo!
                default:
                    break
                }
                print(label.text ?? "")
                label.isHidden = false
            }
            
            //Corner background
            if node.name == "BackgroundShape" {
                if let shapeNodeU = node as? SKShapeNode{
                    shapeNodeU.fillColor = SKColor.clear
                    
                    let cropNode = SKCropNode.init()
                    let shapeNode = SKShapeNode(rect: shapeNodeU.frame, cornerRadius: 10.0)
                    //shapeNode.path = UIBezierPath(roundedRect: CGRect(x: -49,y:-10,width: 100, height: 61), cornerRadius: 50).cgPath
                    shapeNode.fillColor = SKColor.white
                    cropNode.maskNode = shapeNode
                    shapeNodeU.addChild(shapeNode)
                }
            }
            
            //Image
            if node.name == "Image" {
                if self.image == nil {
                    if let img = self.part?.img {
                        let session = URLSession.shared
                        guard let url = URL(string : img) else {
                            return
                        }
                        session.dataTask(with: url){ (data,response,err) in
                            if let error = err {
                                print("Error requesting data, check for internet connection : ",error.localizedDescription)
                            }
                            guard let data = data else{
                                return
                            }
                            self.image = UIImage(data: data)
                            if self.image != nil {
                                let texture = SKTexture(image: self.image!)
                                DispatchQueue.main.async {
                                    if let ImageSpriteNode = node.childNode(withName: "ImageSprite") as? SKSpriteNode {
                                        ImageSpriteNode.texture = texture
                                    }
                                }
                            }
                            }.resume()
                    }
                }
            }
        }
    }
    override func didLoad(_ node: SKNode?) {
        self.rootNode = node
        updateData(node:node)
    }
}
