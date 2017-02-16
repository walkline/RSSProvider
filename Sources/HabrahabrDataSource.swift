//
//  HabrahabrDataSource.swift
//  RSSProvider
//
//  Created by Anton on 15.02.17.
//
//

import Foundation
import AEXML

enum HabrahabrFeeds: String {
    case all = "https://habrahabr.ru/rss/all/"
    case interesting = "https://habrahabr.ru/rss/interesting/"
    
    func url() -> URL? {
        return URL(string: rawValue)
    }
}

open class HabrahabrDataSource: DataSourceProtocol {
    public var tagsGenerator: TagsGeneratorProtocol? = HabrahabrTagsGenerator()

    public var sourceURL: URL? {
        return self.feed.url()
    }
 	
    var feed: HabrahabrFeeds
    
    init(feed: HabrahabrFeeds = .all) {
        self.feed = feed
    }
}
