//
//  StartGameView.swift
//  pegglegame
//
//  Created by kevin chua on 20/1/22.
//

import SwiftUI

struct StartGameView: View {

    /// Adapted from: https://stackoverflow.com/a/57333873
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.isPresented) var isPresented

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
        }
        .onChange(of: isPresented) { newValue in
            if !newValue {
                startGameViewModel.resetAllProperties()
            }
        }
        .alert(isPresented: $startGameViewModel.alert.visible) {
            Alert(
                title:
                    Text(
                        startGameViewModel.alert.title
                    ),
                message: Text(startGameViewModel.alert.message),
                dismissButton: .default(Text("Go back")) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .navigationBarTitleDisplayMode(.inline)
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
                    .onChanged { value in gesturePos = value.location }
                    .onEnded { value in startGameViewModel.shootBall(from: cannonLoc, to: value.location) }
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
            } else if let gameObjectHitComponent = gameObject.getComponent(of: ActivateOnHitComponent.self) {
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
                generateScoreMessageView(gameObject: gameObject)
            }

            // Show Free ball
            generateFreeBallMessageView(gameObject: gameObject)
        }
    }

    @ViewBuilder
    private func generateScoreMessageView(gameObject: GameObject) -> some View {
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
                    Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { _ in
                        gameObject.getComponent(of: ScoreComponent.self)?.hide()
                    }
                }
        }
    }

    @ViewBuilder
    private func generateFreeBallMessageView(gameObject: GameObject) -> some View {
        if gameObject.getComponent(of: BucketComponent.self)?.freeBallMsgShown ?? false {
            Text("Free Ball!")
                .bold()
                .shadow(color: .gray, radius: 4)
                .foregroundColor(.red)
                .font(.largeTitle)
                .transition(AnyTransition.opacity
                                .animation(.easeInOut(duration: 0.1)))
                .position(gameObject.coordinates)
                .offset(x: 0, y: -65.0)
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 1.4, repeats: false) { _ in
                        gameObject.getComponent(of: BucketComponent.self)?.hideMsg()
                    }
                }
        }
    }

    private func generateBottomBarView() -> some View {
        HStack {
            VStack {
                Text("Score:")
                Text("\(startGameViewModel.scoreEngine.score)")
                    .font(.largeTitle)
            }
                .padding()
            Spacer()

            Text("Balls remaining: \(startGameViewModel.scoreEngine.noOfBallsRemaining)")
                .font(.body)
            VStack {
                Text(
                    "Pegs hit: \(startGameViewModel.getNoOfPegHit())/\(startGameViewModel.getInitialNoOfPegHit())"
                )
                    .font(.body)
                Text("""
                     Orange Pegs hit: \(startGameViewModel.noOrngePegHit())/\(startGameViewModel.initialNoOrngePeg())
                     """)
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
