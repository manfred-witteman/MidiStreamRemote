//
//  SceneSource.swift
//  bla
//
//  Created by manfred on 19/11/2024.
//


struct SceneSource: Identifiable, Equatable {
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
