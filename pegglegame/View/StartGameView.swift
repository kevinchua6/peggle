//
//  StartGameView.swift
//  pegglegame
//
//  Created by kevin chua on 20/1/22.
//

import SwiftUI

struct StartGameView: View {
    @ObservedObject var startGameViewModel: StartGameViewModel

    var score = 0
    var noBluePegHit = 0
    var noOrangePegHit = 0
    @State var gCannonPos = CGPoint(x: 0.0, y: 0.0)
    @State var gesturePos = CGPoint(x: 0.0, y: 0.0)

    var body: some View {
        return VStack {
            ZStack {
                generateGameBoardView()
                VStack {
                    HStack {
                        Spacer()
                        Spacer()
                    }.fixedSize()
                    Spacer()
                }
            }
            generateBottomBarView()
        }
        // TODO: Find a way to make the pegs consistent without hiding the back button
        .navigationBarHidden(true)
    }

    private func generateCannonView(position: CGPoint) -> some View {
        Image("Cannon")
            .resizable()
            .frame(width: 90, height: 90)
            .rotationEffect(
                .radians(Double(
                    startGameViewModel.getCannonAngle(cannonLoc: position, gestureLoc: self.gesturePos
                                                     )
                )
                        )
            )
            .gesture(DragGesture(minimumDistance: 0)
                        .onEnded({ value in
                            print(value)
            }))
            .position(position)
    }

    private func generateGameBoardView() -> some View {
        GeometryReader { geometry in
            let bounds = geometry.frame(in: .local)
            let cannonLoc = CGPoint(x: bounds.width / 2, y: bounds.height / 12)
            ZStack {
                Image("Background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.keyboard)

                ForEach(startGameViewModel.objArr) { gameObject in
                    generateGameObjectView(gameObject: gameObject, bounds: bounds)
                }
                generateCannonView(position: cannonLoc)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        gesturePos = value.location
                    }
                    .onEnded { value in
                        startGameViewModel.placeObj(at: value.location)
                        startGameViewModel.shootBall(from: cannonLoc, to: value.location)
                    }
            )
            .onAppear {
                startGameViewModel.createWalls(bounds: bounds)
            }
        }
    }

    @ViewBuilder
    private func generateGameObjectView(gameObject: GameObject, bounds: CGRect) -> some View {
        if let gameObjectImage = gameObject.imageName {
            Image(gameObjectImage)
                .resizable()
                .frame(width: 40, height: 40)
                .position(gameObject.coordinates)
        }
    }

    private func generateBottomBarView() -> some View {
        HStack {
            Text("Score: \(score)")
                .font(.largeTitle)
                .padding()
            Spacer()
            VStack {
                Text("Blue Pegs hit: \(noBluePegHit)")
                    .font(.body)
                Text("Orange Pegs hit: \(noOrangePegHit)")
                    .font(.body)
            }
        }
        .background(Color.white)
    }

}

struct StartGameView_Previews: PreviewProvider {
    static var previews: some View {
        LevelDesignerView(levelDesignerViewModel: LevelDesignerViewModel())
    }
}
