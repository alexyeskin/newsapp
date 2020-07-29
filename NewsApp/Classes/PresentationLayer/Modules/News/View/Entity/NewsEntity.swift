//
//  NewsEntity.swift
//  NewsApp
//
//  Created by Alexander Eskin on 11/13/19.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Foundation
import UIKit

struct NewsEntity: Codable, Equatable, Hashable {
    var source: String
    var sourceImageName: String
    var imageURL: String
    var publishDate: Date
    var title: String
    var description: String
    let link: String
    var isSaved: Bool
}
