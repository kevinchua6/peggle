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

    var body: some View {
        VStack {
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
                    .radians(Double(startGameViewModel.getAngle(from: cannonPos, to: self.position)))
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
//                            .onEnded({ value in
//                                if keyboardResponder.isKeyboardOpen {
//                                    return
//                                }
//                                placeholderObj.isVisible = false
//                                // Add peg at that location if it is valid
//                                if self.placeholderObj.isValid {
//                                    levelDesignerViewModel.placeObj(at: value.location)
//                                }
//                                self.placeholderObj.isValid = true
//                            })
                    )
                
                ForEach(startGameViewModel.objArr) { entity in
                    generateGameObjectView(gameObject: entity, bounds: bounds)
                }
            }
        }
    }
    
    private func generateGameObjectView(gameObject: GameObject, bounds: CGRect) -> some View {
        Image(gameObject.imageName)
            .resizable()
            .frame(width: 40, height: 40)
            // we want it to adjust by the keyboard amount
            .position(gameObject.physicsBody.coordinates)
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
