//import Foundation
//
//// Create static data sources
//var sceneSources: [SceneSource] = [
//    SceneSource(id: 1, sourceName: "Slideshow Presentation", inputKind: "slideshow_v2", sceneItemEnabled: true, level: Double.random(in: 0...1)),
//    SceneSource(id: 2, sourceName: "Vampire", inputKind: "ffmpeg_source", sceneItemEnabled: true, level: Double.random(in: 0...1)),
//    SceneSource(id: 3, sourceName: "Microphone Input", inputKind: "sck_audio_capture", sceneItemEnabled: false, level: Double.random(in: 0...1)),
//    SceneSource(id: 4, sourceName: "Color Overlay", inputKind: "color_source_v3", sceneItemEnabled: true, level: Double.random(in: 0...1)),
//    SceneSource(id: 5, sourceName: "Logo Image", inputKind: "image_source", sceneItemEnabled: true, level: Double.random(in: 0...1)),
//    SceneSource(id: 6, sourceName: "Overlay Text", inputKind: "text_ft2_source_v2", sceneItemEnabled: false, level: Double.random(in: 0...1)),
//    SceneSource(id: 7, sourceName: "Webcam Feed", inputKind: "unknown", sceneItemEnabled: true, level: Double.random(in: 0...1)),
//    SceneSource(id: 8, sourceName: "Imperial March", inputKind: "ffmpeg_source", sceneItemEnabled: true, level: Double.random(in: 0...1))
//]
//
//var secondarySceneSources: [SceneSource] = [
//    SceneSource(id: 9, sourceName: "Background Music", inputKind: "media_input", sceneItemEnabled: true, level: Double.random(in: 0...1)),
//    SceneSource(id: 10, sourceName: "Gaming Console", inputKind: "capture_device", sceneItemEnabled: true, level: Double.random(in: 0...1)),
//    SceneSource(id: 11, sourceName: "Chat Overlay", inputKind: "browser_source", sceneItemEnabled: false, level: Double.random(in: 0...1)),
//    SceneSource(id: 12, sourceName: "Animated Emotes", inputKind: "gif_source", sceneItemEnabled: true, level: Double.random(in: 0...1))
//]
//
//var tertiarySceneSources: [SceneSource] = [
//    SceneSource(id: 13, sourceName: "Nature Background", inputKind: "image_source", sceneItemEnabled: true, level: Double.random(in: 0...1)),
//    SceneSource(id: 14, sourceName: "Host Webcam", inputKind: "camera_source", sceneItemEnabled: true, level: Double.random(in: 0...1)),
//    SceneSource(id: 15, sourceName: "Donation Alert", inputKind: "browser_source", sceneItemEnabled: true, level: Double.random(in: 0...1)),
//    SceneSource(id: 16, sourceName: "Countdown Timer", inputKind: "text_timer_source", sceneItemEnabled: false, level: Double.random(in: 0...1)),
//    SceneSource(id: 17, sourceName: "Stock Ticker", inputKind: "text_scroller_source", sceneItemEnabled: true, level: Double.random(in: 0...1)),
//    SceneSource(id: 18, sourceName: "Drone Footage", inputKind: "video_stream_input", sceneItemEnabled: true, level: Double.random(in: 0...1)),
//    SceneSource(id: 19, sourceName: "Voice Changer", inputKind: "audio_effect_source", sceneItemEnabled: false, level: Double.random(in: 0...1)),
//    SceneSource(id: 20, sourceName: "Custom Border", inputKind: "image_overlay_source", sceneItemEnabled: true, level: Double.random(in: 0...1)),
//    SceneSource(id: 21, sourceName: "Virtual Avatar", inputKind: "avatar_tracking_source", sceneItemEnabled: true, level: Double.random(in: 0...1)),
//    SceneSource(id: 22, sourceName: "Breaking News Bar", inputKind: "scrolling_text_source", sceneItemEnabled: true, level: Double.random(in: 0...1))
//]
//
//var scene1 = Scene(id: 1, name: "Scene 1", sources: sceneSources)
//var scene2 = Scene(id: 2, name: "Scene 2", sources: secondarySceneSources)
//var scene3 = Scene(id: 3, name: "Scene 3", sources: tertiarySceneSources)
