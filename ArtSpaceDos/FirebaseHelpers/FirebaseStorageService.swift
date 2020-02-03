//
//  FirebaseStorageService.swift
//  ArtSpaceDos
//
//  Created by Levi Davis on 2/3/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import Foundation
import FirebaseStorage

class FirebaseStorageService {
    static let manager = FirebaseStorageService()
    
    private let storage: Storage!
    private let storageReference: StorageReference
    private let imagesFolderReference: StorageReference
    
    private init() {
        storage = Storage.storage()
        storageReference = storage.reference()
        imagesFolderReference = storageReference.child("images")
    }
    
    func storeImage(image: Data, completion: @escaping (Result<URL, Error>) -> ()) {
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        let uuid = UUID()
        let imageLocation = imagesFolderReference.child(uuid.description)
        imageLocation.putData(image, metadata: metaData) { (responseMetaData, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                imageLocation.downloadURL { (url, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        guard let url = url else {completion(.failure(error!)); return}
                        completion(.success(url))
                    }
                }
            }
        }
    }
}
