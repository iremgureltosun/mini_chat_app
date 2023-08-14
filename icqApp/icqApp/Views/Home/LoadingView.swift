//
//  LoadingView.swift
//  icqApp
//
//  Created by Tosun, Irem on 11.08.2023.
//

import SwiftUI

struct LoadingView: View {
    let message: String

    var body: some View {
        HStack(spacing: 10) {
            ProgressView()
                .tint(.white)
            Text(message)
        }.padding(10)
            .background(.gray)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(message: "Sending....")
    }
}
