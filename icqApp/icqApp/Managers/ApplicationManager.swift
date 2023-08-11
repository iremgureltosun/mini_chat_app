//
//  ApplicationManager.swift
//  icqApp
//
//  Created by Tosun, Irem on 10.07.2023.
//

import Foundation
enum LoadingState: Hashable, Identifiable {
    case idle
    case loading(String)

    var id: Self {
        return self
    }
}

enum Route: Hashable {
    case home
    case chat
    case settings
}

class ApplicationManager: ObservableObject {
    @Published var loadingState: LoadingState = .idle
    @Published var routes: [Route]
    static let shared = ApplicationManager() // The singleton instance

    private init() {
        // Private initializer prevents external instantiation
        routes = []
    }
}
