//
//  RenderObject.swift
//  KlutterIOS
//
//  Created by Konrad Painta on 29/12/2025.
//

import Foundation

struct AppData: Codable {
    let data: [RenderObject]
}

struct RenderObject: Codable {
    let x, y: Float
    let height, width: Float
    let r, g, b, a: Float
}
