import Foundation
import Combine

class SceneStore: ObservableObject {
    @Published var sceneList: [APIResponse] = []  // Initially empty
    @Published var isLoading: Bool = true         // Initially set to true
    
    // Method to update the scene data (replace MockScenes)
    func updateSceneData(_ newScenes: [APIResponse]) {
        DispatchQueue.main.async {
            self.sceneList = newScenes
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
}
