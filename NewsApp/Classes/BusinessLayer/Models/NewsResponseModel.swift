//
//  NewsResponseModel.swift
//  NewsApp
//
//  Created by Alexander Eskin on 11/13/19.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Foundation

struct NewsResponseModel: Codable, Equatable, Hashable {
    var source: String
    var sourceImageName: String
    var imageURL: String
    var date: Date
    var title: String
    var description: String
    var link: String
    var isSaved: Bool
}
