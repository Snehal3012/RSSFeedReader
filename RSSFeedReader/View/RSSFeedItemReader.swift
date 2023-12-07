//
//  RSSFeedItemReader.swift
//  RSSFeedReader
//
//  Created by Snehal Firodia on 06/12/23.
//

import SwiftUI
import FeedKit
import SwiftData

struct RSSFeedItemReader: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var feedItems: [RSSFeedItemModel]
    @Query private var items: [FeedStore]
    @State var imageUrl: RSSFeedImage?
    @State private var selectedLink: String?
    
    var body: some View {
        List {
            ForEach($feedItems) { feedItem in
                HStack {
                    if let imageUrl = imageUrl {
                        AsyncImage(url: URL(string: imageUrl.url ?? "")) { image in
                            image
                                .resizable()
                                .frame(width: 20, height: 20)
                                .clipped()
                        } placeholder: {
                            ProgressView()
                                .frame(width: 30, height: 30)
                        }
                    } else {
                        Image(systemName: "newspaper.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .clipped()
                    }
                    
                    Spacer()
                        .frame(width: 15)
                    
                    Text(feedItem.rssFeedItem.title.wrappedValue ?? "")
                        .font(.body)
                    
                    Spacer()
                    
                    Button {
                        if !feedItem.bookMark.wrappedValue {
                            feedItem.bookMark.wrappedValue = true
                            addItem(item: feedItem.rssFeedItem.wrappedValue)
                        } else {
                            feedItem.bookMark.wrappedValue = false
                            
                        }
                    } label: {
                        Image(systemName: feedItem.bookMark.wrappedValue ? "bookmark.fill" : "bookmark")
                            .resizable()
                            .foregroundStyle(Color.black)
                            .frame(width: 15, height: 20)
                            .clipped()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding([.trailing], 5)
                }
                .onTapGesture {
                    if let url = feedItem.rssFeedItem.link.wrappedValue {
                        self.selectedLink = url
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
        .sheet(item: $selectedLink) { link in
            WebView(url: link)
        }
        
    }
    
    func addItem(item: RSSFeedItem) {
        withAnimation {
            let newItem = FeedItem(title: item.title ?? "", isBookMarked: true)
            modelContext.insert(newItem)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    RSSFeedItemReader(feedItems: .constant([]))
}
