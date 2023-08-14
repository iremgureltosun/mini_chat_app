//
//  LaunchView.swift
//  icqApp
//
//  Created by Tosun, Irem on 10.08.2023.
//

import SwiftUI

struct LaunchView: View {
    private let textInput = "Let's Chat!"
    private let typingInterval: TimeInterval = 0.1 // Adjust the typing speed here
    @State private var welcomeText = ""
    @State private var isShowingText: Bool = true
    @State private var taskStarted = false
    @EnvironmentObject private var appManager: ApplicationManager
    var body: some View {
        NavigationView {
            ZStack {
                Image("launch")
                    .onAppear {
                        Task {
                            if !taskStarted {
                                try await Task.sleep(nanoseconds: 3_000_000_000)
                                appManager.routes.append(.home)
                                taskStarted = true
                            }
                        }
                    }

                VStack {
                    if isShowingText {
                        withAnimation(.easeInOut(duration: 3.5)) {
                            Text(welcomeText)
                                .font(.title)
                                .opacity(1)
                                .transition(.opacity)
                                .onAppear {
                                    startTypingEffect(textInput)
                                }
                        }
                        .onAppear {
                            Task {
                                // Hide the text after 3.5 second
                                try await Task.sleep(nanoseconds: 3_500_000_000)
                                withAnimation {
                                    isShowingText = false
                                }
                            }
                        }
                    }
                }
                .onAppear {
                    Task {
                        // Show the text after 0.5 second delay
                        try await Task.sleep(nanoseconds: 500_000_000)
                        withAnimation {
                            isShowingText = true
                        }
                    }
                }
            }
        }
    }

    private func startTypingEffect(_ fullText: String) {
        var currentIndex = fullText.startIndex // Start from the beginning of the string
        let timer = Timer.scheduledTimer(withTimeInterval: typingInterval, repeats: true) { timer in
            if currentIndex < fullText.endIndex {
                welcomeText.append(fullText[currentIndex])
                currentIndex = fullText.index(after: currentIndex)
            } else {
                timer.invalidate()
            }
        }
        timer.fire()
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
