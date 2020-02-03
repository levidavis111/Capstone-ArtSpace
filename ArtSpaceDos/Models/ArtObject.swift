//
//  ArtObject.swift
//  ArtSpaceDos
//
//  Created by Jocelyn Boyd on 1/30/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//


import Foundation
import FirebaseFirestore

struct ArtObject {
    let artDescription: String
    let artImageURL: String
    let artID: String
    let sellerID: String
    let price: Double
    let soldStatus: Bool = false
    let dateCreated: Date?
    let tags: [String]
    
//    MARK: - Init
  
    init(artDescription: String, artImageURL: String, sellerID: String, price: Double, dateCreated: Date? = nil, tags: [String]){
        self.artDescription = artDescription
        self.artImageURL = artImageURL
        self.artID = UUID().uuidString
        self.sellerID = sellerID
        self.price = price
        self.dateCreated = dateCreated
        self.tags = tags
    }
    
    init?(from dict: [String:Any], id: String) {
        guard let artDescription = dict["artDescription"] as? String,
        let artImageURL = dict["artImageURL"] as? String,
        let artID = dict["artID"] as? String,
        let sellerID = dict["sellerID"] as? String,
        let price = dict["price"] as? Double,
        let dateCreated = (dict["dateCreated"] as? Timestamp)?.dateValue(),
        let tags = dict["tags"] as? [String] else {return nil}
        
        
        self.artDescription = artDescription
        self.artImageURL = artImageURL
        self.sellerID = sellerID
        self.price = price
        self.dateCreated = dateCreated
        self.artID = artID
        self.tags = tags
    }
    
    var fieldsDict: [String:Any] {
        return ["artDescription": self.artDescription, "artImageURL": self.artImageURL, "artID": self.artID, "sellerID": self.sellerID, "price": self.price, "tags": self.tags ]
    }
    
}
