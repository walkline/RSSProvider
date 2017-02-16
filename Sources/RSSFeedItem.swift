//
//  RSSFeedItem.swift
//  RSSProvider
//
//  Created by Anton on 15.02.17.
//
//

import Foundation

open class RSSFeedItem {
    public var title: String
    public var link: URL?
    public var description: String
    public var pubDate: Date
    
    public var payloadData: Data?
    
    public var tags: [String] {
        guard let tagsGenerator = tagsGenerator else {
            return []
        }
        
    	return tagsGenerator.generateTagsFrom(feedItem: self)
    }
    
    init(withTagsGenerator tagsGenerator: TagsGeneratorProtocol? = nil) {
        self.title = ""
        self.description = ""
        self.pubDate = Date()
        self.payloadData = Data()
        
        self.tagsGenerator = tagsGenerator
    }
    
    internal var tagsGenerator: TagsGeneratorProtocol?
}
