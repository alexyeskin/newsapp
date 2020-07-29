//
//  Parser.swift
//  NewsApp
//
//  Created by Alexander Eskin on 11/24/19.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import FeedKit
import Foundation
import UIKit

class ParserCoreImp: ParserCore {
    func parseTutByNews(from feed: Feed) -> [NewsResponseModel] {
        var news: [NewsResponseModel] = []
        
        guard let feed = feed.rssFeed,
            let feedItems = feed.items
            else {
                return []
        }
        for item in feedItems {
            guard let title = item.title,
                let link = item.link,
                let itemDescription = item.description,
                let pubdate = item.pubDate
                else {
                    return []
            }
            let description = itemDescription.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            let imageURL = item.media?.mediaContents?[0].attributes?.url
            
            let article = NewsResponseModel(source: Constants.NewsSourceName.tutby,
                                            sourceImageName: Constants.NewsSourceImageName.tutby,
                                            imageURL: imageURL ?? "",
                                            date: pubdate,
                                            title: title,
                                            description: description,
                                            link: link,
                                            isSaved: false
            )
            
            news.append(article)
        }
        
        return news
    }
    
    func parseVergeNews(from feed: Feed) -> [NewsResponseModel] {
        var news: [NewsResponseModel] = []
        
        guard let feed = feed.atomFeed,
            let feedEntries = feed.entries
            else {
                return []
        }
        
        for entry in feedEntries {
            guard let title = entry.title,
                let entryContent = entry.content?.value,
                let link = entry.id,
                let pubdate = entry.published
                else {
                    return []
            }
            
            let description = parseDescription(from: entryContent)
            let imageURL = entryContent.getImageURL()
            
            let article = NewsResponseModel(source: Constants.NewsSourceName.theVerge,
                                            sourceImageName: Constants.NewsSourceImageName.theVerge,
                                            imageURL: imageURL,
                                            date: pubdate,
                                            title: title,
                                            description: description,
                                            link: link,
                                            isSaved: false
            )
            
            news.append(article)
        }
        
        return news
    }
    
    private func obtainSavedNews() -> [NewsResponseModel] {
        var savedNews: [NewsResponseModel] = []
        if let saved = UserDefaults.standard.object(forKey: Constants.Keys.savedNews) as? Data {
            if let loaded = try? JSONDecoder().decode([NewsResponseModel: [ArticleDetailResponseModel]].self, from: saved) {
                savedNews = Array(loaded.keys)
            }
        }
        
        return savedNews
    }
    
    private func parseDescription(from content: String) -> String {
        var description: String = ""
        
        let range = NSRange(location: 0, length: content.utf16.count)
        guard let regEx = try? NSRegularExpression(pattern: #"<p id=".*>.*<\/p>"#, options: [.caseInsensitive]) else {
            return ""
        }
        let matches = regEx.matches(in: content, options: [], range: range)
        let resultArray = matches.map { match -> String in
            let range: Range = Range(match.range, in: content) ?? content.startIndex..<content.endIndex
            return String(content[range])
        }
        
        resultArray.forEach { result in
            let descriptionResult = try? result.strippingHTML()
            description.append(descriptionResult ?? "")
        }
        
        return description
    }
    
    func parseVergeHTML(html: String) -> [String] {
        let begin = #"<div class="c-entry-content ""#
        let end = #"<div class="u-hidden-text""#
        
        var clippedHTML = ""
        
        if let startIndex = html.range(of: begin)?.lowerBound, let endIndex = html.range(of: end)?.lowerBound {
            clippedHTML = String(html[startIndex..<endIndex])
        }
        
        let range = NSRange(location: 0, length: clippedHTML.utf16.count)
        let pattern = #"(<p.*<\/p>|<img .*>|<figcaption>.*|<h2.*<\/h2>|<li>.*<\/li>)"#
        guard let regEx = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else {
            return []
        }
        let matches = regEx.matches(in: clippedHTML, options: [], range: range)
        
        let parsedHTML = matches.map { match -> String in
            let range: Range = Range(match.range, in: clippedHTML) ?? clippedHTML.startIndex..<clippedHTML.endIndex
            return String(clippedHTML[range])
        }
        return parsedHTML
    }
    
    func parseTutByHTML(html: String) -> [String] {
        let begin = #"<div id="article_body""#
        let end = #"class="b-article-info""#
        let endWithRelatedNews = #"<div class="related-t">"#
        let endWithAddition = #"<div class="b-addition m-simplify">"#
        
        var clippedHTML = ""
        
        if let startIndex = html.range(of: begin)?.lowerBound, let endIndex = html.range(of: endWithAddition)?.lowerBound {
            clippedHTML = String(html[startIndex..<endIndex])
        } else if let startIndex = html.range(of: begin)?.lowerBound, let endIndex = html.range(of: endWithRelatedNews)?.lowerBound {
            clippedHTML = String(html[startIndex..<endIndex])
        } else if let startIndex = html.range(of: begin)?.lowerBound, let endIndex = html.range(of: end)?.lowerBound {
            clippedHTML = String(html[startIndex..<endIndex])
        }
        
        let range = NSRange(location: 0, length: clippedHTML.utf16.count)
        let pattern = #"(<p.*<\/p>|<img .*>|<figcaption>.*|<h2.*<\/h2>|<li>.*<\/li>)"#
        guard let regEx = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else {
            return []
        }
        let matches = regEx.matches(in: clippedHTML, options: [], range: range)
        let results = matches.map { match -> String in
            let range: Range = Range(match.range, in: clippedHTML) ?? clippedHTML.startIndex..<clippedHTML.endIndex
            return String(clippedHTML[range])
        }
        
        var parsedHTML: [String] = []
        if results.last?.contains("advertising") ?? false {
            parsedHTML = results.dropLast()
        } else {
            parsedHTML = results
        }
        return parsedHTML
    }
    
    func parseArticleDetails(from results: [String]) -> [ArticleDetailResponseModel] {
        var articleDetails: [ArticleDetailResponseModel] = []
        
        for result in results {
            if result.hasPrefix("<p><img") {
                let imageURL = result.getImageURL()
                let image = ArticleDetailResponseModel.imageDetail(imageURL)
                articleDetails.append(image)
            } else if result.hasPrefix("<p") {
                if let pTagText = try? result.strippingHTML() {
                    let text = ArticleDetailResponseModel.textDetail(pTagText)
                    articleDetails.append(text)
                }
            } else if result.hasPrefix("<img") {
                if result.count > 35 {
                    let imageURL = result.getImageURL()
                    let image = ArticleDetailResponseModel.imageDetail(imageURL)
                    articleDetails.append(image)
                }
            } else if result.hasPrefix("<li") {
                if var liTagText = try? result.strippingHTML() {
                    liTagText.insert(contentsOf: "•  ", at: liTagText.startIndex)
                    let text = ArticleDetailResponseModel.textDetail(liTagText)
                    articleDetails.append(text)
                }
            } else if result.hasPrefix("<h2") {
                if let hTagText = try? result.strippingHTML() {
                    let text = ArticleDetailResponseModel.headingDetail(hTagText)
                    articleDetails.append(text)
                }
            } else if result.hasPrefix("<figcaption") {
                if let imgCaptionText = try? result.strippingHTML() {
                    let text = ArticleDetailResponseModel.imageCaptionDetail(imgCaptionText)
                    articleDetails.append(text)
                }
            }
        }
        
        print(articleDetails)
        return articleDetails
    }
}
