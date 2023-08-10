//
//  NewsItem.swift
//  icqApp
//
//  Created by Tosun, Irem on 26.07.2023.
//

import Foundation

struct NewsItem: Identifiable, Codable {
    var id = UUID()
    let title: String
    let body: String
    let date: Date

    private enum CodingKeys: String, CodingKey {
        case title
        case body
        case date
    }
}
