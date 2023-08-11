//
//  ErrorView.swift
//  icqApp
//
//  Created by Tosun, Irem on 11.08.2023.
//

import SwiftUI

struct ErrorWrapper: Identifiable {
    let id = UUID()
    let error: Error
    var guidance: String = ""
}
