//
//  MockScenes.swift
//  bla
//
//  Created by manfred on 23/11/2024.
//


import Foundation

struct MockScenes {
    static var sceneList: [APIResponse] = [
        APIResponse(
            sceneIndex: 1, sceneName: "Scene 1",
            sources: [
                SceneItem(id: 1, sourceName: "Slideshow Presentation", inputKind: "slideshow_v2", sceneItemEnabled: true, level: Double.random(in: 0...1)),
                SceneItem(id: 2, sourceName: "Vampire", inputKind: "ffmpeg_source", sceneItemEnabled: true, level: Double.random(in: 0...1)),
                SceneItem(id: 3, sourceName: "Microphone Input", inputKind: "sck_audio_capture", sceneItemEnabled: false, level: Double.random(in: 0...1)),
                SceneItem(id: 4, sourceName: "Color Overlay", inputKind: "color_source_v3", sceneItemEnabled: true, level: Double.random(in: 0...1)),
                SceneItem(id: 5, sourceName: "Logo Image", inputKind: "image_source", sceneItemEnabled: true, level: Double.random(in: 0...1)),
                SceneItem(id: 6, sourceName: "Overlay Text", inputKind: "text_ft2_source_v2", sceneItemEnabled: false, level: Double.random(in: 0...1)),
                SceneItem(id: 7, sourceName: "Webcam Feed", inputKind: "unknown", sceneItemEnabled: true, level: Double.random(in: 0...1)),
                SceneItem(id: 8, sourceName: "Imperial March", inputKind: "ffmpeg_source", sceneItemEnabled: true, level: Double.random(in: 0...1))
            ]
        ),
        APIResponse(
            sceneIndex: 2, sceneName: "Scene 2",
            sources: [
                SceneItem(id: 1, sourceName: "Cosmic Slideshow", inputKind: "slideshow_v2", sceneItemEnabled: true, level: Double.random(in: 0...1)),
                SceneItem(id: 2, sourceName: "Vampire Bat Beats", inputKind: "ffmpeg_source", sceneItemEnabled: true, level: Double.random(in: 0...1)),
                SceneItem(id: 3, sourceName: "Laser Microphone", inputKind: "sck_audio_capture", sceneItemEnabled: true, level: Double.random(in: 0...1)),
                SceneItem(id: 4, sourceName: "Electric Color Burst", inputKind: "color_source_v3", sceneItemEnabled: true, level: Double.random(in: 0...1)),
                SceneItem(id: 5, sourceName: "Meme Generator", inputKind: "image_source", sceneItemEnabled: true, level: Double.random(in: 0...1)),
                SceneItem(id: 6, sourceName: "Disco Overlay Text", inputKind: "text_ft2_source_v2", sceneItemEnabled: false, level: Double.random(in: 0...1)),
                SceneItem(id: 7, sourceName: "Giant Robot Webcam", inputKind: "unknown", sceneItemEnabled: true, level: Double.random(in: 0...1)),
                SceneItem(id: 8, sourceName: "Space Funk Imperial March", inputKind: "ffmpeg_source", sceneItemEnabled: true, level: Double.random(in: 0...1)),
                SceneItem(id: 9, sourceName: "Zombie Apocalypse Slideshow", inputKind: "slideshow_v2", sceneItemEnabled: true, level: Double.random(in: 0...1)),
                SceneItem(id: 10, sourceName: "Dragon Roar Audio", inputKind: "sck_audio_capture", sceneItemEnabled: false, level: Double.random(in: 0...1))
            ]
        ),
        APIResponse(
            sceneIndex: 3, sceneName: "Scene 3",
            sources: [
                SceneItem(id: 4, sourceName: "Color Overlay", inputKind: "color_source_v3", sceneItemEnabled: true, level: Double.random(in: 0...1)),
                SceneItem(id: 3, sourceName: "Laser Microphone", inputKind: "sck_audio_capture", sceneItemEnabled: true, level: Double.random(in: 0...1))
            ]
        )
    ]
    
    
    
}
