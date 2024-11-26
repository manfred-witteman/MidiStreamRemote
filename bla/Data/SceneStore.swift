import SwiftUI

    class SceneStore: ObservableObject {
        @Published var sceneList: [APIResponse] = MockScenes.sceneList
        
        // Method to update a SceneItem
        func updateSceneItem(sceneIndex: Int, updatedItem: SceneItem) {
            // Ensure the scene index is valid
            guard sceneList.indices.contains(sceneIndex) else {
                print("Invalid scene index: \(sceneIndex)")
                return
            }
            
            // Find the scene and update the corresponding SceneItem
            var scene = sceneList[sceneIndex]
           
            if let index = scene.sources.firstIndex(where: { $0.id == updatedItem.id }) {
                scene.sources[index] = updatedItem // Update the item
                sceneList[sceneIndex] = scene // Replace the scene with the updated one
            } else {
                print("SceneItem with id \(updatedItem.id) not found.")
            }
        }
    }
