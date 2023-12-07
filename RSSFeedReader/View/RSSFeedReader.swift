//
//  RSSFeedReader.swift
//  RSSFeedReader
//
//  Created by Snehal Firodia on 05/12/23.
//

import SwiftUI
import FeedKit
import SwiftData

struct RSSFeedReader: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var feed: [RSSFeed] = []
    @State private var parsedCount = 0
    @State private var reload = false
    @State var feedItem: [RSSFeedItemModel] = []
    @State private var showAddFeedAlert: Bool = false
    @State private var feedTitle: String = ""
    @State private var feedUrl: String = ""
    @State private var isFetching = true
    
    @State var feedUrls: [URL] = {
        if let urlString = URL(string: "https://medium.com/feed/backchannel"),
           let urlString2 = URL(string: "https://medium.com/feed/the-economist") {
            return [urlString, urlString2]
        } else {
            return []
        }
    }()
    
    var body: some View {
        NavigationView {
            ZStack {
                if isFetching {
                    ProgressView()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.primary)
                } else {
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                showAddFeedAlert = true
                            } label: {
                                Text("Add Feed")
                                    .font(.body)
                                    .foregroundStyle(Color.black)
                            }
                        }
                        .frame(alignment: .trailing)
                        .padding(5)
                                                
                        List {
                            ForEach($feed) { feed in
                                Section {
                                    NavigationLink {
                                        RSSFeedItemReader(feedItems: $feedItem, imageUrl: feed.image.wrappedValue)
                                    } label: {
                                        Text(feed.title.wrappedValue ?? "")
                                            .font(.body)
                                    }
                                    
                                    .onAppear {
                                        getFeedItems(feed: feed.wrappedValue)
                                    }
                                }
                            }
                        }
                        .listStyle(.insetGrouped)
                    }
                }
            }
            .padding(16)
            .navigationTitle("Feed Reader")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            let feeds = await self.feeds(for: feedUrls)
            feed = feeds
        }
        .alert("Add Feed", isPresented: $showAddFeedAlert) {
            TextField("Enter feed name", text: $feedTitle)
            TextField("Enter feed url", text: $feedUrl)
               
            Button("Cancel", role: .cancel) {
                dismiss()
            }
            Button("Add") {
                feedUrls.append(URL(string: feedUrl) ?? URL(fileURLWithPath: ""))
                isFetching = true
                Task {
                    feed = await self.feeds(for: feedUrls)
                }
            }
        } message: {
            Text("Enter feed details")
         }
    }
        
    func getFeedItems(feed: RSSFeed) {
        for item in feed.items ?? [] {
            feedItem.append(RSSFeedItemModel(rssFeedItem: item, bookMark: loadBookMarked(item: item)))
        }
    }
    
    private func loadBookMarked(item: RSSFeedItem) -> Bool {
        if let title = item.title {
            let fetchDescriptor = FetchDescriptor<FeedStore>(predicate: #Predicate { feed in
                feed.feed.title == title && feed.feed.isBookMarked == true
            })
            do {
                let feedStoreItem = try modelContext.fetch(fetchDescriptor)
                if feedStoreItem.count == 1 {
                    return true
                }
            } catch {
                
            }
        }
        return false
    }
}

extension RSSFeedReader {
    func feeds(for feedURLs: [URL]) async -> [RSSFeed] {
        let taskResult = await withTaskGroup(of: Optional<RSSFeed>.self, returning: [RSSFeed].self) {
            group in
            for feedURL in feedURLs {
                group.addTask {
                    let parser = FeedParser(URL: feedURL)
                    let result = await parser.asyncParse()
                    switch result {
                    case let .success(feed):
                        switch feed {
                        case .rss(let rssFeed):
                            isFetching = false
                            return rssFeed
                        default:
                            break
                        }
                        return (nil)
                    case .failure(_):
                        return (nil)
                    }
                }
            }
            var result: [RSSFeed] = []
            for
                await feedResult in group {
                if let feed = feedResult {
                    result.append(feed)
                }
            }
            return result
        }
            return taskResult
    }
}

#Preview {
    RSSFeedReader()
}

