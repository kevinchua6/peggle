//
//  StartGameView.swift
//  pegglegame
//
//  Created by kevin chua on 20/1/22.
//

import SwiftUI

struct StartGameView: View {
    @ObservedObject var startGameViewModel: StartGameViewModel

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
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
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
        if let gameObjectImage = gameObject.imageName {
            if !(gameObject.getComponent(of: ActivateOnHitComponent.self)?.isHit ?? false) {
                Image(gameObjectImage)
                    .resizable()
                    .frame(
                        width: gameObject.boundingBox.width,
                        height: gameObject.boundingBox.height
                    )
                    .position(gameObject.coordinates)
            } else if let gameObjectHitComponent = gameObject.getComponent(of: ActivateOnHitComponent.self)  {
                ZStack {
                    Image(gameObjectHitComponent.imageNameHit)
                        .resizable()
                        .frame(
                            width: gameObject.boundingBox.width,
                            height: gameObject.boundingBox.height
                        )
                        .position(gameObject.coordinates)
                        .transition(AnyTransition.opacity
                                        .animation(.easeOut(duration: 0.3)))
                    
                    // Show score
                    if gameObject.getComponent(of: ScoreComponent.self)?.isShown ?? false {
                        Text("+\(gameObject.getComponent(of: ScoreComponent.self)?.score ?? 0)")
                            .bold()
                            .shadow(color: .gray, radius: 4)
                            .foregroundColor(.blue)
                            .font(.title)
                            .transition(AnyTransition.opacity
                                            .animation(.easeInOut(duration: 0.3)))
                            .position(gameObject.coordinates)
                            .offset(x: 0, y: 35.0)
                            .onAppear {
                                Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { timer in
                                    gameObject.getComponent(of: ScoreComponent.self)?.hide()
                                }
                            }
                    }
                }
            }
            
            // Show Free ball
            if gameObject.getComponent(of: BucketComponent.self)?.freeBallMsgShown ?? false {
                Text("Free Ball!")
                    .bold()
                    .shadow(color: .gray, radius: 4)
                    .foregroundColor(.orange)
                    .font(.largeTitle)
                    .transition(AnyTransition.opacity
                                    .animation(.easeInOut(duration: 0.1)))
                    .position(gameObject.coordinates)
                    .offset(x: 0, y: -65.0)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 1.4, repeats: false) { timer in
                            gameObject.getComponent(of: BucketComponent.self)?.hideMsg()
                        }
                    }
            }

        }
    }

    private func generateBottomBarView() -> some View {
        HStack {
            VStack {
                Text("Score:")
                Text("\(startGameViewModel.getScore())")
                    .font(.largeTitle)
            }
                .padding()
            Spacer()
            VStack {
                Text("Pegs hit: \(startGameViewModel.getNoOfPegHit())")
                    .font(.body)
                Text("Orange Pegs hit: \(startGameViewModel.getNoOfOrangePegHit())")
                    .font(.body)
            }
            .padding()
        }
        .background(Color.white)
    }

}

struct StartGameView_Previews: PreviewProvider {
    static var previews: some View {
        LevelDesignerView(levelDesignerViewModel: LevelDesignerViewModel())
    }
}
