//
//  Image+.swift
//  icqApp
//
//  Created by Tosun, Irem on 10.08.2023.
//

import Foundation
import SwiftUI

extension Image {
    func rounded(width: CGFloat = 100, height: CGFloat = 100) -> some View {
        return resizable()
            .frame(width: width, height: height)
            .clipShape(Circle())
    }
}
