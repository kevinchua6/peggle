//
//  StartMenuView.swift
//  pegglegame
//
//  Created by kevin chua on 22/2/22.
//

import SwiftUI

struct StartMenuView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 90) {
                LogoView()
                generateStartButtonView()
                    .padding(.bottom, 300)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(
                AngularGradient(gradient: Gradient(colors: [.green, .cyan, .green, .yellow, .green]), center: .center)
            )

        }

        .navigationViewStyle(StackNavigationViewStyle())

        
    }

    
    private func generateStartButtonView() -> some View {
        VStack(spacing: 40) {
            NavigationLink(destination: LazyView {
                LevelDesignerView(levelDesignerViewModel: LevelDesignerViewModel())
            }) {
                Text("START GAME")
                    .font(.title)
                    .padding()
                    .frame(width: 250 , height: 60, alignment: .center)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(18)
            }
            
            NavigationLink(destination: LazyView {
                LevelDesignerView(levelDesignerViewModel: LevelDesignerViewModel())
            }) {
                Text("LEVEL DESIGNER")
                    .font(.title)
                    .padding()
                    .frame(width: 300 , height: 60, alignment: .center)
                    .background(.indigo)
                    .foregroundColor(.white)
                    .cornerRadius(18)
            }
        }
    }
    
}

struct StartMenuView_Previews: PreviewProvider {
    static var previews: some View {
        StartMenuView()
    }
}
