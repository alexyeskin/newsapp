//
//  SharedStorageCore.swift
//  NewsApp
//
//  Created by Alexander Eskin on 1/8/20.
//  Copyright © 2020 PixelPlex. All rights reserved.
//

import Foundation

final class SharedStorageCore: StorageCore {
    var storage: KeyValueStoring = SharedStorage()
}
