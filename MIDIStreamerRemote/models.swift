//
//  models.swift
//  MIDIStreamerRemote
//
//  Created by manfred on 24/10/2024.
//
import Foundation

// Define CommandMetadata as a dictionary type alias
typealias CommandMetadata = [String: String]

// Define OBSCommand to be Codable and Identifiable
struct OBSCommand: Identifiable, Decodable, Encodable {
    var id = UUID()
    var name: String
    var detail1: String
    var detail2: String
    var controllerType: ControllerType
    var metadata: CommandMetadata
    var icon: String
}



// Define CommandType as an enum for the type of command
enum ControllerType: String, Codable {
    case absolute
    case relative
    case none
    case noteOn
}
