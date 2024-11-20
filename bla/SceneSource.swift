struct SceneSource: Identifiable, Equatable {
    var id: Int
    var sourceName: String
    var inputKind: String
    var sceneItemEnabled: Bool
    var level: Double

    // This will compare SceneSource objects to detect changes
    static func == (lhs: SceneSource, rhs: SceneSource) -> Bool {
        return lhs.id == rhs.id && lhs.sceneItemEnabled == rhs.sceneItemEnabled && lhs.level == rhs.level
    }
}
