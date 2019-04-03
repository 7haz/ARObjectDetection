//
//  dataRetrive.swift
//  ARKitVision
//
//  Created by Hodd on 3/28/19.
//  Copyright © 2019 Apple. All rights reserved.
//
import UIKit

struct Part: Decodable {
    let _id : String?
    let title : String
    let price : String
    let car : String
    let year : String
    let link : String
    let img : String
    
    init(json: [String:Any]){
        _id   = json["_id"]   as? String
        title = json["title"] as? String ?? ""
        price = json["price"] as? String ?? ""
        car   = json["car"]   as? String ?? ""
        year  = json["year"]  as? String ?? ""
        link  = json["link"]  as? String ?? ""
        img   = json["img"]   as? String ?? ""
    }
}
