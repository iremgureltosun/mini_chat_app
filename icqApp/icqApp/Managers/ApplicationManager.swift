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
}

class ApplicationManager: ObservableObject {
    @Published var routes: [Route] = []
}
