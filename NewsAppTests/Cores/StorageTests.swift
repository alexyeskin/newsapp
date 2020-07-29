//
//  StorageTests.swift
//  NewsAppTests
//
//  Created by Alexander Eskin on 1/9/20.
//  Copyright © 2020 PixelPlex. All rights reserved.
//

import XCTest
@testable import NewsApp

class StorageTests: XCTestCase {
    
    func testStoringString() {
        
        //arrange
        let storage = AppDelegate.applicationAssembler.assembler.resolver.resolve(StorageCore.self)!
        let stringKey = "Key"
        let stringValue = "Value"
        
        //act
        storage.set(key: stringKey, value: stringValue)
        let storing = storage.get(key:stringKey)
        
        storage.remove(key: stringKey)
        let deleted = storage.get(key:stringKey)
        
        //assert
        XCTAssertEqual(stringValue, storing)
        XCTAssertNil(deleted)
    }
    
    
}

