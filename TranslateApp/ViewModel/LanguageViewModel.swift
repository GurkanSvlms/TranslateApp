//
//  LanguageViewModel.swift
//  TranslateApp
//
//  Created by Ali Gürkan Sevilmis on 2.08.2023.
//

import Foundation

class LanguageViewModel {
    private let service: LanguageService
    var languages: [LanguageModel] = []
    
    init(service: LanguageService = LanguageService()) {
        self.service = service
    }
    
    //dil modellerini çekmek için servis sınıfından alır
    func fetchLanguages(completion: @escaping (Error?) -> Void) {
        service.fetchLanguages { [weak self] languages, error in
            if let languages = languages {
                //başarılı
                self?.languages = languages
                completion(nil)
            } else if let error = error {
                //başarısız
                completion(error)
            }
        }
    }
    
    //belirtilen indeksteki dil modelini dönüştürür
    
    func selectedLanguage(at index: Int) -> LanguageModel {
        return languages[index]
    }
    
    //eleman sayısı
    var numberOfLanguages: Int {
        return languages.count
    }
}
