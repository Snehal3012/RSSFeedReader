//
//  FeedReader+Extension.swift
//  RSSFeedReader
//
//  Created by Snehal Firodia on 05/12/23.
//

import Foundation
import FeedKit

extension FeedParser {
    func asyncParse() async -> Result<Feed, ParserError> {
        await withCheckedContinuation { continuation in
            self.parseAsync(queue: DispatchQueue(label: "my.concurrent. queue",
                                                  attributes: .concurrent)) { result in
                continuation.resume(returning: result)
            }
        }
    }
}

extension String: Identifiable {
    public var id: String { self }
}

extension RSSFeed: Identifiable {
}

extension RSSFeedItem: Identifiable {
}
