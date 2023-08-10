//
//  NewsModel.swift
//  icqApp
//
//  Created by Tosun, Irem on 26.07.2023.
//

import Foundation

class NewsModel: ObservableObject {
    @Published private(set) var newsItems: [NewsItem] = []

    func add(_ items: [NewsItem]) {
        var tempItems = newsItems
        tempItems.append(contentsOf: items)
        newsItems = tempItems.sorted {
            $0.date > $1.date
        }
    }
}

extension NewsModel {
    static let shared = mockModel()
    private static func mockModel() -> NewsModel {
        let newsModel = NewsModel()
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard
            let url = Bundle.main.url(forResource: "MockNewsItems", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let newsItems = try? decoder.decode([NewsItem].self, from: data)
        else {
            return newsModel
        }
        newsModel.add(newsItems)
        return newsModel
    }
}
