//
//  SelectObjectView.swift
//  pegglegame
//
//  Created by kevin chua on 22/2/22.
//

import SwiftUI
import CoreGraphics

struct SelectObjectView: View {
    let obj: GameObject
    let bounds: CGRect

    @ObservedObject var levelDesignerViewModel: LevelDesignerViewModel

    init(obj: GameObject, bounds: CGRect, levelDesignerViewModel: LevelDesignerViewModel) {
        self.obj = obj
        self.bounds = bounds
        self.levelDesignerViewModel = levelDesignerViewModel
    }

    var body: some View {
        ZStack {
            Rectangle()
                .stroke(.white, lineWidth: 2)
                .frame(
                    width: obj.physicsBody.boundingBox.width,
                    height: obj.physicsBody.boundingBox.height
                )
                .position(obj.coordinates)
                .allowsHitTesting(false)
            generateResizeCornersView()

            if obj.hasComponent(of: OscillatingComponent.self) {
                generateSpringynessView()
            }
            
        }
    }

    private func generateSpringynessView() -> some View {
        Circle()
            .strokeBorder(Color.blue, lineWidth: 30)
            .frame(
                width: (( obj.getComponent(of: OscillatingComponent.self)?.springRadius ?? 0 ) * 2),
                height: (( obj.getComponent(of: OscillatingComponent.self)?.springRadius ?? 0 ) * 2)
            )
            .position(obj.coordinates)
            .opacity(0.4)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        levelDesignerViewModel.updateSpringRadius(obj: obj, radius:
                                PhysicsEngineUtils.CGPointDistance(from: obj.coordinates, to: value.location))
                    }
            )
    }

    enum Corner {
        case TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT
    }

    private func generateResizeCornersView() -> some View {
        ZStack {
            generateResizeCornerView(corner: Corner.TOP_LEFT)
                .position(x: obj.physicsBody.boundingBox.minX,
                          y: obj.physicsBody.boundingBox.minY)
            generateResizeCornerView(corner: Corner.TOP_RIGHT)
                .position(x: obj.physicsBody.boundingBox.maxX,
                          y: obj.physicsBody.boundingBox.minY)
            generateResizeCornerView(corner: Corner.BOTTOM_LEFT)
                .position(x: obj.physicsBody.boundingBox.minX,
                          y: obj.physicsBody.boundingBox.maxY)
            generateResizeCornerView(corner: Corner.BOTTOM_RIGHT)
                .position(x: obj.physicsBody.boundingBox.maxX,
                          y: obj.physicsBody.boundingBox.maxY)
        }
    }

    private func generateResizeCornerView(corner: Corner) -> some View {
        Rectangle()
            .frame(width: 12, height: 12)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if corner == Corner.BOTTOM_LEFT || corner == Corner.TOP_LEFT {
                            levelDesignerViewModel.updateWidth(gameObject: obj, width: -value.location.x + obj.physicsBody.boundingBox.width,
                                                               bounds: self.bounds)
                        } else if corner == Corner.BOTTOM_RIGHT || corner == Corner.TOP_RIGHT {
                            levelDesignerViewModel.updateWidth(gameObject: obj, width: value.location.x + obj.physicsBody.boundingBox.width,
                                                               bounds: self.bounds)
                        }
                    }
            )
    }
}
