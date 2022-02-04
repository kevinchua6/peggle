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
    @State var position: CGPoint = CGPoint(x: 0.0, y: 0.0)
//    @State var hey: GameRenderer = startGameViewModel.gameRenderer
    
    var body: some View {
//        print(startGameViewModel.gameRenderer.toUpdate)
        return VStack {
            ZStack {
                generateGameBoardView()
                VStack {
                    HStack {
                        Spacer()
                        generateCannonView()
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
    
    private func generateCannonView() -> some View {
        GeometryReader { geometry in
            let cannonPos = geometry.frame(in: .global).origin
            Image("Cannon")
                .resizable()
                .frame(width: 70, height: 70)
                .rotationEffect(
                    .radians(Double(startGameViewModel.getCannonAngle(cannonLoc: cannonPos, gestureLoc: self.position)))
                )
            }
    }
    
    private func generateGameBoardView() -> some View {
        GeometryReader { geometry in
            let bounds = geometry.frame(in: .local)
            ZStack {
                Image("Background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.keyboard)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                position = value.location
                            }
                            .onEnded { value in
                                startGameViewModel.placeObj(at: value.location)
                            }
                    )
                ForEach(startGameViewModel.objArr) { gameObject in
                    generateGameObjectView(gameObject: gameObject, bounds: bounds)
                }
            }
        }
    }
    
    private func generateGameObjectView(gameObject: GameObject, bounds: CGRect) -> some View {
//        print(hey.toUpdate)
        return Image(gameObject.imageName)
            .resizable()
            .frame(width: 40, height: 40)
            .position(gameObject.coordinates)
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
//        .frame(height: 200)
        .background(Color.white)
    }
    
}

struct StartGameView_Previews: PreviewProvider {
    static var previews: some View {
        LevelDesignerView(levelDesignerViewModel: LevelDesignerViewModel())
    }
}
