//
//  AppUser.swift
//  ArtSpaceDos
//
//  Created by Jocelyn Boyd on 1/30/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
fileprivate let imageURLKey = "profileImageURL"
struct AppUser {
    let userName: String?
    let email: String?
    let uid: String
    let dateCreated: Date?
    let profileImageURL: String?
    
    init(from user: User) {
        self.userName = user.displayName
        self.email = user.email
        self.uid = user.uid
        self.profileImageURL = user.photoURL?.absoluteString
        self.dateCreated = user.metadata.creationDate
    }
    
//    MARK: - Failable init
    init?(from dict: [String: Any], id: String) {
        guard let userName = dict["userName"] as? String,
        let email = dict["email"] as? String,
        let profileImageURL = dict["profileImageURL"] as? String else {return nil}
        let dateCreated = (dict["dateCreated"] as? Timestamp)?.dateValue()
        
        self.userName = userName
        self.email = email
        self.dateCreated = dateCreated
        self.uid = id
        self.profileImageURL = profileImageURL
    }
    
    var fieldsDict: [String:Any] {

        return ["userName": self.userName ?? "", "email": self.email ?? "", "uid": self.uid, "profileImageURL": self.profileImageURL ?? ""]
    }
    
}
