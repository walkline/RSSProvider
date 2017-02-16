//
//  DataSourceProtocol.swift
//  RSSProvider
//
//  Created by Anton on 15.02.17.
//
//

import Foundation
import AEXML

enum DataSourceErrors: Error {
    case dataIsEmpty
    case urlIsEmpty
}

public typealias FetchCompletion = (RSSFeed?, Error?) -> Void

public protocol DataSourceProtocol {
    var tagsGenerator: TagsGeneratorProtocol? { get }
    var sourceURL: URL? { get }

    func fetch(completion: @escaping FetchCompletion)
    
    func parseData(_ data: Data) throws -> RSSFeed
}


let rssDateFormatter = RFC822DateFormatter()

extension DataSourceProtocol  {
    public func fetch(completion: @escaping FetchCompletion) {
        guard let sourceURL = self.sourceURL else {
            completion(nil, DataSourceErrors.urlIsEmpty)
            return
        }

        let request = URLRequest(url: sourceURL)

        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue()) { (_, data, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, DataSourceErrors.dataIsEmpty)
                return
            }
            
            do {
                completion(try self.parseData(data), nil)
            } catch {
                completion(nil, error)
                return
            }
        }
    }
    
    public func parseData(_ data: Data) throws -> RSSFeed {
        let feed = RSSFeed()
        let xml: AEXMLDocument
        do {
            xml = try AEXMLDocument(xml: data)
            
            feed.title = xml.root["channel"]["title"].string
            feed.link = URL(string: xml.root["channel"]["link"].string)
            feed.description = xml.root["channel"]["description"].string
            feed.pubDate = rssDateFormatter.date(from: xml.root["channel"]["pubDate"].string) ?? Date()
            
            if let items = xml.root["channel"]["item"].all {
                for xmlItem in items {
                    
                    let item = RSSFeedItem(withTagsGenerator: self.tagsGenerator)
                    
                    item.title = xmlItem["title"].string
                    item.link = URL(string: xmlItem["link"].string)
                    item.description = xmlItem["description"].string
                    item.pubDate = rssDateFormatter.date(from: xmlItem["pubDate"].string) ?? Date()
                    
                    item.payloadData = xmlItem.xml.data(using: .utf8)
                    
                    feed.items.append(item)
                }
            }
            
        } catch {
            throw error
        }
        
        return feed
    }
}
