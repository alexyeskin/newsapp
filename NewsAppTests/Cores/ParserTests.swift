//
//  ParserTests.swift
//  NewsAppTests
//
//  Created by Alexander Eskin on 1/9/20.
//  Copyright © 2020 PixelPlex. All rights reserved.
//

import XCTest
@testable import NewsApp

class ParserTests: XCTestCase {
    
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
    
    func testParsingTutByHTML() {
        //arrange
        let parser = AppDelegate.applicationAssembler.assembler.resolver.resolve(ParserCore.self)!
        let html = HTML().getTutByHTML(for: "tutByHTML")
        let expected = TestConstants.expectedTutByHTML
        
        //act
        let parsed = parser.parseTutByHTML(html: html)
        
        //assert
        XCTAssertEqual(expected, parsed)
    }
    
    func testParsingVergeHTML() {
        //arrange
        let parser = AppDelegate.applicationAssembler.assembler.resolver.resolve(ParserCore.self)!
        let html = HTML().getTutByHTML(for: "vergeHTML")
        let expected = TestConstants.expectedVergeHTML
        
        //act
        let parsed = parser.parseVergeHTML(html: html)
        
        //assert
        XCTAssertEqual(expected, parsed)
    }
    
    func testParsingArticleDetails() {
        //arrange
        let parser = AppDelegate.applicationAssembler.assembler.resolver.resolve(ParserCore.self)!
        let parsedHTML = TestConstants.expectedVergeHTML
        let expected = TestConstants.articleDetails
        
        //act
        let parsed = parser.parseArticleDetails(from: parsedHTML)
        
        //assert
        XCTAssertEqual(expected, parsed)
    }
    
    
    
}

//func parseTutByNews(from feed: Feed) -> [NewsResponseModel]
//func parseVergeNews(from feed: Feed) -> [NewsResponseModel]
//func parseTutByHTML(html: String) -> [String]
//func parseVergeHTML(html: String) -> [String]
//func parseArticleDetails(from results: [String]) -> [ArticleDetailResponseModel]
