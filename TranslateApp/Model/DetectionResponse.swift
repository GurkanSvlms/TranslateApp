//
//  DetectionModel.swift
//  TranslateApp
//
//  Created by Ali Gürkan Sevilmis on 7.08.2023.
//


struct DetectionResponse: Codable {
    let data: DetectionData
}

struct DetectionData: Codable {
    let detections: [[DetectionResult]]
}

struct DetectionResult: Codable {
    let language: String
    let isReliable: Bool
    let confidence: Int
}


