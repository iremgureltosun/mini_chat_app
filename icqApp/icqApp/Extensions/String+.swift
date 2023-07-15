//
//  String+.swift
//  icqApp
//
//  Created by Tosun, Irem on 10.07.2023.
//

import Foundation

extension String {
    var isEmptyOrWhiteSpace: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
