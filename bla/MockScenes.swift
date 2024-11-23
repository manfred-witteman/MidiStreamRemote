//
//  MockScenes.swift
//  bla
//
//  Created by manfred on 23/11/2024.
//


import Foundation

struct MockScenes {
    static let sceneList: [APIResponse] = [
        APIResponse(
            sceneName: "Scene 1",
            sources: [
                SceneSource(id: 1, sourceName: "Slideshow Presentation", inputKind: "slideshow_v2", sceneItemEnabled: true, level: Double.random(in: 0...1)),
                SceneSource(id: 2, sourceName: "Vampire", inputKind: "ffmpeg_source", sceneItemEnabled: true, level: Double.random(in: 0...1)),
                SceneSource(id: 3, sourceName: "Microphone Input", inputKind: "sck_audio_capture", sceneItemEnabled: false, level: Double.random(in: 0...1)),
                SceneSource(id: 4, sourceName: "Color Overlay", inputKind: "color_source_v3", sceneItemEnabled: true, level: Double.random(in: 0...1)),
                SceneSource(id: 5, sourceName: "Logo Image", inputKind: "image_source", sceneItemEnabled: true, level: Double.random(in: 0...1)),
                SceneSource(id: 6, sourceName: "Overlay Text", inputKind: "text_ft2_source_v2", sceneItemEnabled: false, level: Double.random(in: 0...1)),
                SceneSource(id: 7, sourceName: "Webcam Feed", inputKind: "unknown", sceneItemEnabled: true, level: Double.random(in: 0...1)),
                SceneSource(id: 8, sourceName: "Imperial March", inputKind: "ffmpeg_source", sceneItemEnabled: true, level: Double.random(in: 0...1))
            ]
        ),
        APIResponse(
            sceneName: "Scene 2",
            sources: [
                SceneSource(id: 1, sourceName: "Cosmic Slideshow", inputKind: "slideshow_v2", sceneItemEnabled: true, level: Double.random(in: 0...1)),
                SceneSource(id: 2, sourceName: "Vampire Bat Beats", inputKind: "ffmpeg_source", sceneItemEnabled: true, level: Double.random(in: 0...1)),
                SceneSource(id: 3, sourceName: "Laser Microphone", inputKind: "sck_audio_capture", sceneItemEnabled: true, level: Double.random(in: 0...1)),
                SceneSource(id: 4, sourceName: "Electric Color Burst", inputKind: "color_source_v3", sceneItemEnabled: true, level: Double.random(in: 0...1)),
                SceneSource(id: 5, sourceName: "Meme Generator", inputKind: "image_source", sceneItemEnabled: true, level: Double.random(in: 0...1)),
                SceneSource(id: 6, sourceName: "Disco Overlay Text", inputKind: "text_ft2_source_v2", sceneItemEnabled: false, level: Double.random(in: 0...1)),
                SceneSource(id: 7, sourceName: "Giant Robot Webcam", inputKind: "unknown", sceneItemEnabled: true, level: Double.random(in: 0...1)),
                SceneSource(id: 8, sourceName: "Space Funk Imperial March", inputKind: "ffmpeg_source", sceneItemEnabled: true, level: Double.random(in: 0...1)),
                SceneSource(id: 9, sourceName: "Zombie Apocalypse Slideshow", inputKind: "slideshow_v2", sceneItemEnabled: true, level: Double.random(in: 0...1)),
                SceneSource(id: 10, sourceName: "Dragon Roar Audio", inputKind: "sck_audio_capture", sceneItemEnabled: false, level: Double.random(in: 0...1))
            ]
        ),
        APIResponse(
            sceneName: "Scene 3",
            sources: [
                SceneSource(id: 5, sourceName: "Webcam Feed", inputKind: "video_input", sceneItemEnabled: true, level: Double.random(in: 0...1)),
                SceneSource(id: 6, sourceName: "Color Overlay", inputKind: "color_source", sceneItemEnabled: false, level: Double.random(in: 0...1))
            ]
        )
    ]
}
