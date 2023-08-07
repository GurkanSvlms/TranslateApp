//
//  TranslationViewModel.swift
//  TranslateApp
//
//  Created by Ali Gürkan Sevilmis on 5.08.2023.
//

import Foundation

class TranslationViewModel {
    private let translationService = TranslationService()
    
    //    çeviri için servis sınıfını kullanur
    func translate(inputText: String, sourceLanguage: String, targetLanguage: String, completion: @escaping (Result<String, Error>) -> Void) {
        translationService.translateText(inputText: inputText, sourceLanguage: sourceLanguage, targetLanguage: targetLanguage) { result in
            switch result {
                //başarılıa
            case .success(let translatedText):
                completion(.success(translatedText))
                //başarısız
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
