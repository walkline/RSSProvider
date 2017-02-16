//
//  HabrahabrTagsGenerator.swift
//  RSSProvider
//
//  Created by Anton on 15.02.17.
//
//

import Foundation
import AEXML

open class HabrahabrTagsGenerator: TagsGeneratorProtocol {
    open func generateTagsFrom(feedItem: RSSFeedItem) -> [String] {
        guard let payload = feedItem.payloadData, let xml = try? AEXMLDocument(xml: payload) else {
            return []
        }
        
        var tags: [String] = []
        if let xmlTags = xml["item"]["category"].all {
            for tag in xmlTags {
                tags.append(tag.string)
            }
        }
        
        return tags
    }
}
