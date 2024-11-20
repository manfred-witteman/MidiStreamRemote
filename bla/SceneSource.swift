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
