//
//  RSSFeed.swift
//  RSSProvider
//
//  Created by Anton on 15.02.17.
//
//

import Foundation

open class RSSFeed {
    public var title: String
    public var link: URL?
    public var description: String
    public var pubDate: Date
    
    public var items: [RSSFeedItem]
    
    public init() {
        self.title = ""
        self.description = ""
        self.pubDate = Date()
        self.items = []
    }
}


