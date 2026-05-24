//
//  NewsConfig.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import Foundation

struct NewsRoot: Codable {
    let news: [NewsItem]
}

struct NewsItem: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let body: String
    let category: String
    let icon: String?
    let startDate: String?
    let endDate: String?
    let featured: Bool?

    var isActive: Bool {
        let now = Date()

        if let start = DrakonDateParser.date(from: startDate), now < start {
            return false
        }

        if let end = DrakonDateParser.date(from: endDate), now > end {
            return false
        }

        return true
    }
}

enum NewsLoader {
    static func load() -> [NewsItem] {
        do {
            let root: NewsRoot = try JSONLoader.load("news")
            return root.news
                .filter(\.isActive)
                .sorted {
                    ($0.featured ?? false) && !($1.featured ?? false)
                }
        } catch {
            print("news.json konnte nicht geladen werden:", error)
            return []
        }
    }
}
