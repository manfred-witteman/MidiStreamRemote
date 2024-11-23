//
//  SceneSource 2.swift
//  bla
//
//  Created by manfred on 23/11/2024.
//


import Foundation

struct SceneSource: Identifiable, Equatable, Codable {
    let id: Int
    var sourceName: String
    var inputKind: String
    var sceneItemEnabled: Bool
    var level: Double

    static func == (lhs: SceneSource, rhs: SceneSource) -> Bool {
        return lhs.id == rhs.id &&
               lhs.sourceName == rhs.sourceName &&
               lhs.inputKind == rhs.inputKind &&
               lhs.sceneItemEnabled == rhs.sceneItemEnabled &&
               lhs.level == rhs.level
    }
}

// Assuming this is your API response model
struct APIResponse: Codable {
    let sceneName: String
    let sources: [SceneSource]
}

