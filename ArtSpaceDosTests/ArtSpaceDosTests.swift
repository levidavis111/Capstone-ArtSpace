//
//  ArtSpaceDosTests.swift
//  ArtSpaceDosTests
//
//  Created by Levi Davis on 5/9/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import XCTest

@testable import ArtSpaceDos

class ArtSpaceDosTests: XCTestCase {
    
    func testAppUserFrom() {
        let userName = "Levi"
        let email = "levi@levi.com"
        let profileImageURL = "image.com"
        let blob: [String: Any] = ["userName": userName, "email": email, "profileImageURL": profileImageURL]
        
        let user: AppUser? = AppUser(from: blob, id: "random")
        
        guard user != nil else {XCTFail(); return}
        
    }
    
    func testArtObject() {
        let width: CGFloat = 1.0
        let height: CGFloat = 1.0
        let price: Double = 1.0
        let blob: [String: Any] = ["artistName": "Levi", "artDescription": "Art", "width": width, "height": height, "artImageURL": "art.com", "artID" : "kafjl", "sellerID": "fweiuh", "price": price, "soldStatus": true, "tags": ["tag"]]
        
        let art = ArtObject(from: blob, id: "random")
        guard art != nil else {XCTFail(); return}
    }
    
    /**
     let artistName: String
       let artDescription: String
       let width: CGFloat
       let height: CGFloat
       let artImageURL: String
       let artID: String
       let sellerID: String
       let price: Double
     //MARK: TODO: remove default status
       let soldStatus: Bool = true
       let dateCreated: Date?
       let tags: [String]
     */
}
