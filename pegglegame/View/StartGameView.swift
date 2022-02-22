//
//  StartGameView.swift
//  pegglegame
//
//  Created by kevin chua on 20/1/22.
//

import SwiftUI

struct StartGameView: View {
    @ObservedObject var startGameViewModel: StartGameViewModel

    @State var score = 0
    var noBluePegHit = 0
    var noOrangePegHit = 0

    // Initial positions
    @State var gCannonPos = CGPoint(x: 0.0, y: 0.0)
    @State var gesturePos = CGPoint(x: 0.0, y: 0.0)

    var body: some View {
        VStack {
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
        }.navigationBarTitleDisplayMode(.inline)
    }

    private func generateCannonView(position: CGPoint) -> some View {
        Image("Cannon")
            .resizable()
            .frame(width: 90, height: 90)
            .rotationEffect(
                .radians(Double(
                    startGameViewModel.getCannonAngle(
                        cannonLoc: position, gestureLoc: self.gesturePos
                    )
                )
                        )
            )
            .position(position)
    }

    private func generateGameBoardView() -> some View {
        GeometryReader { geometry in
            let bounds = geometry.frame(in: .local)
            let cannonLoc = CGPoint(x: bounds.width / 2, y: bounds.height / 12)
            ZStack(alignment: .leading) {
                ForEach(startGameViewModel.objArr) { gameObject in
                    generateGameObjectView(gameObject: gameObject, bounds: bounds)
                }
                generateCannonView(position: cannonLoc)
            }
            .background(
                Image("Background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.keyboard),
                alignment: .leading
            )
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        gesturePos = value.location
                    }
                    .onEnded { value in
                        startGameViewModel.shootBall(from: cannonLoc, to: value.location)
                    }
            )
            .onAppear {
                startGameViewModel.setBoundaries(bounds: bounds)
            }
        }
    }

    @ViewBuilder
    private func generateGameObjectView(gameObject: GameObject, bounds: CGRect) -> some View {
        if let gameObjectImage = gameObject.imageName, let gameObjectImageHit = gameObject.imageNameHit {
            if !gameObject.isHit {
                Image(gameObjectImage)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .position(gameObject.coordinates)
                    .opacity(gameObject.opacity)
            } else {
                Image(gameObjectImageHit)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .position(gameObject.coordinates)
                    .opacity(gameObject.opacity)
                    .transition(AnyTransition.opacity
                                    .animation(.easeOut(duration: 0.3)))
            }
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
