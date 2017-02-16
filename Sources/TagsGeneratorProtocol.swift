//
//  TagsGeneratorProtocol.swift
//  RSSProvider
//
//  Created by Anton on 15.02.17.
//
//

import Foundation

public protocol TagsGeneratorProtocol {
    func generateTagsFrom(feedItem: RSSFeedItem) -> [String]
}
