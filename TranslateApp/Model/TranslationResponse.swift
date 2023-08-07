//
//  TranslationResponse.swift
//  TranslateApp
//
//  Created by Ali Gürkan Sevilmis on 5.08.2023.
//

import Foundation

//Servisten gelen response değeri
struct TranslationResponse: Codable {
    let data: TranslationData
}
struct TranslationData: Codable {
    let translations: [Translation]
}

struct Translation: Codable {
    let translatedText: String
}
