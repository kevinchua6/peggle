//
//  EncodablePeg.swift
//  pegglegame
//
//  Created by kevin chua on 27/1/22.
//

struct EncodableObject: Codable {
    var xcoord: Double
    var ycoord: Double
    var width: Double
    var height: Double

    var type: String
}
