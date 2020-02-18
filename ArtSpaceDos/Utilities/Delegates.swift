//
//  Delegates.swift
//  ArtSpaceDos
//
//  Created by God on 2/13/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import UIKit

protocol FilterTheArtDelegate: UIViewController {
    func getTagsToFilter(get tags:[String])
    func cancelFilters()
}

protocol ArtCellFavoriteDelegate: AnyObject {
    func faveArtObject(tag: Int)
}
