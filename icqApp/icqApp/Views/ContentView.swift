//
//  ContentView.swift
//  icqApp
//
//  Created by Tosun, Irem on 10.07.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var buttonWidth: Double = UIScreen.main.bounds.width - 80
    @State private var buttonOffset: CGFloat = 0
    // @State private var isAnimating: Bool = false
    @EnvironmentObject private var appState: ApplicationManager
    
    var body: some View {
        let text = """
        Unlock the power of seamless communication
        """

        ZStack {
            Color(.purple).ignoresSafeArea(.all, edges: .all)

            VStack(spacing: 20) {
                Spacer()

                // MARK: Header

                VStack(spacing: 0) {
                    Group {
                        Text("icqApp.")
                            .font(.system(size: 45))

                        Text(text).multilineTextAlignment(.leading)

                    }.padding(.horizontal, MasterPage.Constant.Space.horizontalPadding)
                        .foregroundColor(.white)
                } //: Header

                // MARK: Center

                ZStack {
                    ZStack {
                        Circle()
                            .stroke(.white.opacity(0.2), lineWidth: 40)
                            .frame(width: MasterPage.Constant.Image.Character.width, height: MasterPage.Constant.Image.Character.height, alignment: .center)
                        Circle()
                            .stroke(.white.opacity(0.2), lineWidth: 80)
                            .frame(width: MasterPage.Constant.Image.Character.width, height: MasterPage.Constant.Image.Character.height, alignment: .center)

                        Image("character-1")
                            .resizable()
                            .scaledToFit()
                    }
                }
                //: Center

                Spacer()

                startButton
                   
            }
        }
    }

    @ViewBuilder var startButton: some View {
        ZStack {
            Capsule().fill(Color.white.opacity(0.2))

            Capsule().fill(Color.white).opacity(0.2).padding(8)
            Text("Get started")
                .foregroundColor(.white)
                .offset(x: 20)

            // Capsule dynamic width
            HStack {
                Capsule()
                    .fill(Color("redBg"))
                    .frame(width: buttonOffset + 80)
                Spacer()
            }

            HStack {
                ZStack {
                    Circle().fill(Color("redBg"))
                    Circle().fill(.black).opacity(0.15).padding(8)
                    Image(systemName: "chevron.right.2")
                        .font(.system(size: 24, weight: .bold))
                }.foregroundColor(.white)
                    .frame(width: 80, height: 80, alignment: .center)
                    .offset(x: buttonOffset) // Automatic view update
                    .gesture(
                        DragGesture()
                            .onChanged { action in
                                if action.translation.width > 0, buttonOffset <= buttonWidth - 80 {
                                    // It will only run when the dragging is from left to right
                                    buttonOffset = action.translation.width
                                }
                            }
                            .onEnded { _ in
                                if buttonOffset > buttonWidth / 2 {
                                    buttonOffset = buttonWidth - 80
                                } else {
                                    self.buttonOffset = 0
                                }
                                Task {
                                    try await Task.sleep(nanoseconds: 1_000_000_000)
                                    appState.routes.append(.home)
                                    self.buttonOffset = 0
                                }
                            }
                    )
                Spacer()
            }
            //: HStack
        }.frame(width: buttonWidth, height: 80, alignment: .center)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
