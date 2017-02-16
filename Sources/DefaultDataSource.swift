//
//  DefaultDataSource.swift
//  RSSProvider
//
//  Created by Anton on 16.02.17.
//
//

import Foundation

open class DefaultDataSource: DataSourceProtocol {
    public var sourceURL: URL?
    public var tagsGenerator: TagsGeneratorProtocol? = nil

    public init(url: URL) {
        self.sourceURL = url
    }
}
