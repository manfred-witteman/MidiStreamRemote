//
//  SceneSource 2.swift
//  bla
//
//  Created by manfred on 23/11/2024.
//


import Foundation

struct SceneItem: Identifiable, Equatable, Codable{
    let id: Int
    var sourceName: String
    var inputKind: String
    var sceneItemEnabled: Bool
    var level: Double

    static func == (lhs: SceneItem, rhs: SceneItem) -> Bool {
        return lhs.id == rhs.id &&
               lhs.sourceName == rhs.sourceName &&
               lhs.inputKind == rhs.inputKind &&
               lhs.sceneItemEnabled == rhs.sceneItemEnabled &&
               lhs.level == rhs.level
    }
}

struct APIResponse: Codable, Equatable {
    let sceneIndex: Int
    let sceneName: String
    let sources: [SceneItem]
}
