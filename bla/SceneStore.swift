//
//  SceneStore.swift
//  bla
//
//  Created by manfred on 25/11/2024.
//


import SwiftUI

class SceneStore: ObservableObject {
    @Published var sceneList: [APIResponse] = MockScenes.sceneList
}