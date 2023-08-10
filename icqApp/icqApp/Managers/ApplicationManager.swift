//
//  ApplicationManager.swift
//  icqApp
//
//  Created by Tosun, Irem on 10.07.2023.
//

import Foundation

enum Route: Hashable {
    case home
    case chat
    case settings
}

class ApplicationManager: ObservableObject {
    @Published var routes: [Route]
    static let shared = ApplicationManager() // The singleton instance

    private init() {
        // Private initializer prevents external instantiation
        routes = []
    }
}
