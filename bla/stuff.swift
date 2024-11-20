import SwiftUICore

extension SceneSource {
    func getIcon(filled: Bool = false) -> String {
        let baseIcon: String
        switch self.inputKind {
        case "slideshow_v2":
            baseIcon = "photo.stack"
        case "ffmpeg_source":
            baseIcon = "waveform.circle"
        case "sck_audio_capture":
            baseIcon = "microphone"
        case "color_source_v3":
            baseIcon = "paintpalette"
        case "image_source":
            baseIcon = "photo"
        case "text_ft2_source_v2":
            baseIcon = "text.page"
        default:
            baseIcon = "questionmark.app"
        }
        
        return filled ? "\(baseIcon).fill" : baseIcon
    }
}


extension SceneSource {
    func getColor() -> Color {
        switch self.inputKind {
        case "slideshow_v2":
            return .green
        case "ffmpeg_source":
            return .red
        case "sck_audio_capture":
            return .blue
        case "color_source_v3":
            return .orange
        case "image_source":
            return .purple
        case "text_ft2_source_v2":
            return .mint
        default:
            return .gray
        }
    }
}
