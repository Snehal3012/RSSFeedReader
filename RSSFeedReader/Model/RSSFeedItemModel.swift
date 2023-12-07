//
//  RSSFeedItemModel.swift
//  RSSFeedReader
//
//  Created by Snehal Firodia on 06/12/23.
//

import SwiftUI
import FeedKit

@Observable
final class RSSFeedItemModel: Identifiable {
    var id: UUID = UUID()
    var rssFeedItem: RSSFeedItem
    var bookMark: Bool
    
    init(rssFeedItem: RSSFeedItem, bookMark: Bool) {
        self.rssFeedItem = rssFeedItem
        self.bookMark = bookMark
    }
}
