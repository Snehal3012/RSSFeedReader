//
//  Item.swift
//  RSSFeedReader
//
//  Created by Snehal Firodia on 05/12/23.
//

import Foundation
import SwiftData
import FeedKit

@Model
class FeedItem {
    var title: String
    var link: String?
    var source: String?
    var isBookMarked: Bool
    
    init(title: String, link: String? = nil, source: String? = nil, isBookMarked: Bool) {
        self.title = title
        self.link = link
        self.source = source
        self.isBookMarked = isBookMarked
    }
}

@Model
final class FeedStore {
    var feed: FeedItem
    
    init(feed: FeedItem) {
        self.feed = feed
    }
}
