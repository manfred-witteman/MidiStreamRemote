import Foundation
import Combine

class SceneStore: ObservableObject {
    @Published var sceneList: [APIResponse] = []  // Initially empty
    @Published var isLoading: Bool = true         // Initially set to true
    
    // Method to update the scene data (replace MockScenes)
    func updateSceneData(_ newScenes: [APIResponse]) {
        DispatchQueue.main.async {
            // Sort the newScenes by sceneOrder before updating the sceneList
            self.sceneList = newScenes.sorted { $0.sceneOrder < $1.sceneOrder }
            print("SceneList updated: \(self.sceneList.map { $0.sceneIndex })")  // Log scene indices without sorting
            self.isLoading = false
        }
    }

    // Method to handle incoming JSON and update the scene list
    func loadData(from jsonData: Data) {
        do {
            let decodedResponse = try JSONDecoder().decode([APIResponse].self, from: jsonData)
            self.updateSceneData(decodedResponse)  // Update the data
        } catch {
            print("Failed to decode JSON: \(error)")
            self.isLoading = false  // In case of an error, stop loading
        }
    }
    
   
    
    // Method to update a specific scene item by sceneIndex and item id
    func updateSceneItem(newItem: ItemUpdate) {
        DispatchQueue.main.async {
            // Find the index of the scene in the sceneList by sceneName
            guard let sceneIdx = self.sceneList.firstIndex(where: { $0.sceneName == newItem.sceneName }) else {
                print("Scene with name \(newItem.sceneName) not found.")
                return
            }
            
            // Find the index of the item in the sources array by sceneItemId
            guard let itemIdx = self.sceneList[sceneIdx].sources.firstIndex(where: { $0.id == newItem.sceneItemId }) else {
                print("SceneItem with ID \(newItem.sceneItemId) not found in scene \(newItem.sceneName).")
                return
            }
            
            // Update the specific SceneItem's enabled state
            self.sceneList[sceneIdx].sources[itemIdx].sceneItemEnabled = newItem.sceneItemEnabled == 1
            
            print("Updated SceneItem with ID \(newItem.sceneItemId) in scene '\(newItem.sceneName)' to enabled: \(newItem.sceneItemEnabled).")
        }
    }
    
}
