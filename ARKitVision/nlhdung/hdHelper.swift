//
//  hdHelper.swift
//  ARNumShooter
//
//  Created by Dung Nguyen on 2/13/19.
//  Copyright © 2019 aivantgoyal. All rights reserved.
//

import UIKit
import VideoToolbox
import SpriteKit

class hdHelper: NSObject {
    static func getOperation() -> (String,Int) {
        let operatorObj = Int.random(in: 1...3)
        let operand1 = Int.random(in: 1...100)
        let operand2 = Int.random(in: 1...100)
        
        switch operatorObj {
        case 1://+
            return ("\(operand1)+\(operand2)=?", operand1+operand2)
        case 2://-
            return ("\(operand1)-\(operand2)=?", operand1-operand2)
        case 3://*
            return ("\(operand1)*\(operand2)=?", operand1*operand2)
        default:
            return ("\(operand1)*\(operand2)=?", operand1*operand2)
        }
    }
}
extension UIImage {
    public convenience init?(pixelBuffer: CVPixelBuffer) {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)
        
        if let cgImage = cgImage {
            self.init(cgImage: cgImage)
        } else {
            return nil
        }
    }
    
    func rotate(byDegrees degree: Double) -> UIImage {
        let radians = CGFloat(degree*M_PI)/180.0 as CGFloat
        let rotatedSize = self.size
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(rotatedSize, false, scale)
        let bitmap = UIGraphicsGetCurrentContext()

        
        bitmap?.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        bitmap?.rotate(by: radians)
        bitmap?.scaleBy(x: 1.0, y: -1.0)
        bitmap?.draw(self.cgImage!, in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        return newImage
    }
    
    func fixOrientation() -> UIImage {
        
        // No-op if the orientation is already correct
        if ( self.imageOrientation == .up ) {
            return self;
        }
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = .identity
        
        if ( self.imageOrientation == .down || self.imageOrientation == .downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: .pi)
        }
        
        if ( self.imageOrientation == .left || self.imageOrientation == .leftMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: .pi/2)
        }
        
        if ( self.imageOrientation == .right || self.imageOrientation == .rightMirrored ) {
            transform = transform.translatedBy(x: 0, y: self.size.height);
            transform = transform.rotated(by: -.pi/2);
        }
        
        if ( self.imageOrientation == .upMirrored || self.imageOrientation == .downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }
        
        if ( self.imageOrientation == .leftMirrored || self.imageOrientation == .rightMirrored ) {
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx: CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                                       bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                       space: self.cgImage!.colorSpace!,
                                       bitmapInfo: self.cgImage!.bitmapInfo.rawValue)!;
        
        ctx.concatenate(transform)
        
        if ( self.imageOrientation == .left ||
            self.imageOrientation == .leftMirrored ||
            self.imageOrientation == .right ||
            self.imageOrientation == .rightMirrored ) {
            ctx.draw(self.cgImage!, in: CGRect(x: 0.0,y: 0.0,width: self.size.height,height: self.size.width))
        } else {
            ctx.draw(self.cgImage!, in: CGRect(x: 0.0,y: 0.0,width: self.size.width,height: self.size.height))
        }
        
        // And now we just create a new UIImage from the drawing context and return it
        return UIImage(cgImage: ctx.makeImage()!)
    }
}

extension SKShapeNode {
    func roundCorners(topLeft:Bool,topRight:Bool,bottomLeft:Bool,bottomRight:Bool,radius: CGFloat,parent: SKNode){
        let newNode = SKShapeNode(rect: self.frame)
        newNode.fillColor = self.fillColor
        newNode.lineWidth = self.lineWidth
        newNode.position = self.position
        newNode.name = self.name
        self.removeFromParent()
        parent.addChild(newNode)
        var corners = UIRectCorner()
        if topLeft { corners = corners.union(.bottomLeft) }
        if topRight { corners = corners.union(.bottomRight) }
        if bottomLeft { corners = corners.union(.topLeft) }
        if bottomRight { corners = corners.union(.topRight) }
        newNode.path = UIBezierPath(roundedRect: CGRect(x: -(newNode.frame.width / 2),y:-(newNode.frame.height / 2),width: newNode.frame.width, height: newNode.frame.height),byRoundingCorners: corners, cornerRadii: CGSize(width:radius,height:radius)).cgPath
    }
}
