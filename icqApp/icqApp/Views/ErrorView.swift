//
//  ErrorView.swift
//  icqApp
//
//  Created by Tosun, Irem on 11.08.2023.
//

import SwiftUI

struct ErrorView: View {
    let errorWrapper: ErrorWrapper

    var body: some View {
        Image("error")
            .resizable()
            .ignoresSafeArea().overlay {
            VStack {
                Text("An error has occurred!")
                    .font(.title)
                    .padding(.bottom)

//                Text(errorWrapper.error.localizedDescription)
//                    .font(.headline)

                Text(errorWrapper.guidance)
                    .font(.caption)
                    .padding(.top)

            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    enum TestError: Error {
        case operationFailed
    }

    static var previews: some View {
        ErrorView(errorWrapper: ErrorWrapper(error: TestError.operationFailed, guidance: "Please try again"))
    }
}
