//
//  FirebaseService.swift
//  ArtSpaceDos
//
//  Created by Jocelyn Boyd on 1/30/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import Foundation
import FirebaseFirestore

fileprivate enum FirestoreCollections: String {
    case AppUser
    case ArtObject
    
}
// MARK: - Add when we add search bar
//enum SortingCriteria: String {
//    case fromNewestToOldest = "dateCreated"
//    var shouldSortDescending: Bool {
//        switch self {
//        case .fromNewestToOldest:
//            return true
//        }
//    }
//}

class FirestoreService {
    
    static let manager = FirestoreService()
    
    private let database = Firestore.firestore()
    
//    MARK: - AppUser Methods
    func createAppUser(user: AppUser, completion: @escaping (Result<(), Error>) -> ()) {
        var fields: [String: Any] = user.fieldsDict
        fields["dateCreated"] = Date()
        database.collection(FirestoreCollections.AppUser.rawValue).document(user.uid).setData(fields) { (error) in
            if let error = error {
                completion(.failure(error))
            }
            completion(.success(()))
        }
    }
    
    func updateCurrentUser(userName: String? = nil, completion: @escaping (Result<(), Error>) -> ()) {
        guard let userID = FirebaseAuthService.manager.currentUser?.uid else {return}
        
        var updateFields = [String:Any]()
        if let user = userName {
            updateFields["userName"] = user
        }
        database.collection(FirestoreCollections.AppUser.rawValue).document(userID).updateData(updateFields) { (error) in
            if let error = error {
                completion(.failure(error))
            }
            completion(.success(()))
        }
    }
    
//    MARK: - ArtObject Methods
    
    func createArtObject(artObject: ArtObject, completion: @ escaping (Result<(), Error>) -> ()) {
        var fields: [String:Any] = artObject.fieldsDict
        fields["dateCreated"] = Date()
        database.collection(FirestoreCollections.ArtObject.rawValue).document(artObject.artID).setData(fields) { (error) in
            if let error = error {
                completion(.failure(error))
            }
            
            completion(.success(()))
        }
    }
    
    func getAllArtObjects(completion: @escaping (Result<[ArtObject], Error>) -> ()) {
        database.collectionGroup(FirestoreCollections.ArtObject.rawValue).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let artObjects = snapshot?.documents.compactMap({ (snapshot) -> ArtObject? in
                    let artObjectID = snapshot.documentID
                    let artObject = ArtObject(from: snapshot.data(), id: artObjectID)
                    return artObject
                })
                completion(.success(artObjects ?? []))
            }
        }
    }
    
    func updateArtObjectSoldStatus(newStatus: Bool?, artID: String, completion: @escaping (Result<(), Error>) -> ()) {
//        guard let userID = FirebaseAuthService.manager.currentUser?.uid else {return}
        var updateFields = [String:Any]()
        if let status = newStatus {
            updateFields["soldStatus"] = status
        }
        
        let artObject = database.collection(FirestoreCollections.ArtObject.rawValue).document(artID)
        artObject.updateData(updateFields) { (error) in
            if let error = error {
                completion(.failure(error))
            }
            completion(.success(()))
        }
    }
    
    //MARK: Just Testing For Filtering Posts
    func getPosts(tags: [String], completion: @escaping (Result<[ArtObject], Error>) -> ()) {
        database.collection(FirestoreCollections.ArtObject.rawValue).whereField("tags", isEqualTo: tags).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let posts = snapshot?.documents.compactMap({ (snapshot) -> ArtObject? in
                    let postID = snapshot.documentID
                    let post = ArtObject(from: snapshot.data(), id: postID)
                    return post
                })
                completion(.success(posts ?? []))
            }
        }
        
    }
}
